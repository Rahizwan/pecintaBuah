<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use App\Http\Resources\ScanResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class ScanController extends Controller
{
    public function index(Request $request)
    {
        $scans = $request->user()->scans()
            ->latest()
            ->paginate(20);

        return ScanResource::collection($scans);
    }

    public function show(Request $request, Scan $scan)
    {
        if ($scan->user_id !== $request->user()->id) {
            abort(403, 'Unauthorized');
        }

        return new ScanResource($scan);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'image' => 'required|image|max:10240',
        ]);

        $result = $this->processImage($request->user()->id, $validated['image'], save: true);

        return (new ScanResource($result['scan']))->additional([
            'metrics' => $result['metrics'],
        ]);
    }

    public function preview(Request $request)
    {
        $validated = $request->validate([
            'image' => 'required|image|max:10240',
        ]);

        $result = $this->processImage($request->user()->id, $validated['image'], save: false);

        return response()->json([
            'id' => 0,
            'image_url' => '/storage/' . $result['image_relative_path'],
            'fruit_type' => $this->normalizeFruitType($result['prediction']['fruit_type']),
            'ripeness_status' => $result['prediction']['ripeness_status'],
            'freshness_level' => $result['prediction']['freshness_level'],
            'confidence' => [
                'fruit_type' => $result['prediction']['confidence']['fruit_type'],
                'ripeness_status' => $result['prediction']['confidence']['ripeness_status'],
                'freshness_level' => $result['prediction']['confidence']['freshness_level'],
            ],
            'created_at' => now()->toIso8601String(),
            'metrics' => $result['metrics'],
        ]);
    }

    public function confirm(Request $request)
    {
        $validated = $request->validate([
            'image_path' => 'required|string',
            'fruit_type' => 'required|string',
            'ripeness_status' => 'required|string',
            'freshness_level' => 'required|string',
            'confidence_fruit_type' => 'required|numeric|min:0|max:1',
            'confidence_ripeness_status' => 'required|numeric|min:0|max:1',
            'confidence_freshness_level' => 'required|numeric|min:0|max:1',
        ]);

        if (!Storage::disk('public')->exists($validated['image_path'])) {
            throw ValidationException::withMessages([
                'image_path' => ['Image not found. Please re-scan.'],
            ]);
        }

        $scan = Scan::create([
            'user_id' => $request->user()->id,
            'image_path' => $validated['image_path'],
            'fruit_type' => $this->normalizeFruitType($validated['fruit_type']),
            'ripeness_status' => $validated['ripeness_status'],
            'freshness_level' => $validated['freshness_level'],
            'confidence_fruit_type' => $validated['confidence_fruit_type'],
            'confidence_ripeness_status' => $validated['confidence_ripeness_status'],
            'confidence_freshness_level' => $validated['confidence_freshness_level'],
            'average_confidence' => ($validated['confidence_fruit_type'] + $validated['confidence_ripeness_status'] + $validated['confidence_freshness_level']) / 3,
        ]);

        // Trigger achievement check after each scan
        $achievementResult = app(AchievementController::class)->check($request);
        $achievementData = $achievementResult->getData(true);

        $response = (new ScanResource($scan))->jsonSerialize();
        $response['new_notifications'] = $achievementData['new_notifications'] ?? [];

        return response()->json($response);
    }

    private function normalizeFruitType(string $fruitType): string
    {
        $map = [
            'apples' => 'apple',
            'oranges' => 'orange',
            'bananas' => 'banana',
        ];

        return $map[strtolower($fruitType)] ?? strtolower($fruitType);
    }

    private function processImage(int $userId, $image, bool $save): array
    {
        $totalStartTime = microtime(true);

        $disk = Storage::disk('public');
        $imageName = Str::uuid() . '.' . $image->getClientOriginalExtension();
        $disk->putFileAs('scans', $image, $imageName);
        $imageRelativePath = 'scans/' . $imageName;

        if (!$disk->exists('scans/' . $imageName)) {
            throw ValidationException::withMessages([
                'image' => ['Failed to store image.'],
            ]);
        }

        $localImagePath = $disk->path('scans/' . $imageName);

        try {
            $fastApiUrl = config('app.fastapi_url') ?? env('FASTAPI_URL', 'http://localhost:8000');
            $predictEndpoint = rtrim($fastApiUrl, '/') . '/api/v1/predict';

            $aiRequestStart = microtime(true);
            $response = Http::timeout(60)->attach(
                'file',
                file_get_contents($localImagePath),
                $imageName
            )->post($predictEndpoint);
            $aiRequestEnd = microtime(true);

            if (!$response->successful()) {
                Log::error('FastAPI prediction failed', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]);
                $disk->delete('scans/' . $imageName);
                throw ValidationException::withMessages([
                    'image' => ['AI prediction failed. Please try again.'],
                ]);
            }

            $prediction = $response->json();
            $aiTime = $aiRequestEnd - $aiRequestStart;

             $dbStart = microtime(true);
             $scan = null;
             if ($save) {
                 // Calculate average confidence and determine if scan is correct
                 $avgConfidence = (
                     $prediction['confidence']['fruit_type'] +
                     $prediction['confidence']['ripeness_status'] +
                     $prediction['confidence']['freshness_level']
                 ) / 3;
                 
                 $isCorrect = $avgConfidence >= 0.83;
                 
               $scan = Scan::create([
                   'user_id' => $userId,
                   'image_path' => $imageRelativePath,
                   'fruit_type' => $this->normalizeFruitType($prediction['fruit_type']),
                  'ripeness_status' => $prediction['ripeness_status'],
                  'freshness_level' => $prediction['freshness_level'],
                  'confidence_fruit_type' => $prediction['confidence']['fruit_type'],
                  'confidence_ripeness_status' => $prediction['confidence']['ripeness_status'],
                  'confidence_freshness_level' => $prediction['confidence']['freshness_level'],
                  'average_confidence' => $avgConfidence,
              ]);
             }
            $dbEnd = microtime(true);

            $totalEndTime = microtime(true);
            $totalTime = $totalEndTime - $totalStartTime;
            $payloadSizeKb = round(filesize($localImagePath) / 1024, 2);

            Log::info('Scan performance metrics', [
                'total_time_seconds' => round($totalTime, 4),
                'ai_inference_time_seconds' => round($aiTime, 4),
                'payload_size_kb' => $payloadSizeKb,
                'saved_to_db' => $save,
            ]);

            return [
                'scan' => $scan,
                'prediction' => $prediction,
                'image_relative_path' => $imageRelativePath,
                'metrics' => [
                    'total_time_seconds' => round($totalTime, 4),
                    'ai_inference_time_seconds' => round($aiTime, 4),
                    'payload_size_kb' => $payloadSizeKb,
                ],
            ];

        } catch (ValidationException $e) {
            throw $e;
        } catch (\Exception $e) {
            Log::error('Scan processing failed', ['error' => $e->getMessage()]);
            $disk->delete('scans/' . $imageName);
            throw ValidationException::withMessages([
                'image' => ['An error occurred during scanning. Please try again.'],
            ]);
        }
    }
}
