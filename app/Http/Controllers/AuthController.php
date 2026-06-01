<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserNotification;
use App\Models\Article;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => Hash::make($validated['password']),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        $newNotifications = [];

        $welcomeNotif = UserNotification::create([
            'user_id' => $user->id,
            'title' => 'Selamat datang di Fruit Scan!',
            'body' => 'Ayo scan buah pertamamu dan raih prestasi!',
            'type' => 'welcome',
        ]);

        $newNotifications[] = [
            'id' => $welcomeNotif->id,
            'title' => $welcomeNotif->title,
            'body' => $welcomeNotif->body,
            'type' => 'welcome',
        ];

        // Create default fruit tips for all users on register
        $defaultArticleTitles = [
            'Behind The Intelligence: How What The Fruits Analyzes Your Food',
            'The Big Three: Essential Health Facts of Apples, Bananas, and Oranges',
        ];

        foreach ($defaultArticleTitles as $title) {
            $article = Article::where('title', $title)->first();
            if ($article) {
                $tipNotif = UserNotification::create([
                    'user_id' => $user->id,
                    'title' => 'Fruit Tips: ' . $article->title,
                    'body' => 'Klik untuk membaca artikel menarik ini.',
                    'type' => 'article_tip',
                    'article_id' => $article->id,
                ]);
                $newNotifications[] = [
                    'id' => $tipNotif->id,
                    'title' => $tipNotif->title,
                    'body' => $tipNotif->body,
                    'type' => 'article_tip',
                    'article_id' => $article->id,
                ];
            }
        }

        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
            ],
            'token' => $token,
            'new_notifications' => $newNotifications,
        ], 201);
    }

    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if (!$user) {
            throw ValidationException::withMessages([
                'email' => ['Email belum terdaftar. Silakan lakukan registrasi terlebih dahulu.'],
            ]);
        }

        if (!Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'password' => ['Password yang dimasukkan salah.'],
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        $newNotifications = UserNotification::where('user_id', $user->id)
            ->whereNull('read_at')
            ->whereIn('type', ['welcome', 'article_tip'])
            ->get()
            ->map(fn($n) => [
                'id' => $n->id,
                'title' => $n->title,
                'body' => $n->body,
                'type' => $n->type,
                'article_id' => $n->article_id,
            ])
            ->values()
            ->toArray();

        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
            ],
            'token' => $token,
            'new_notifications' => $newNotifications,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

      public function user(Request $request)
      {
          $user = $request->user();
          $today = now()->startOfDay();
          $totalScans = $user->scans()->count();
          $averageAcc = $user->scans()->whereNotNull('average_confidence')->avg('average_confidence');
          $accuracy = $totalScans > 0 && !is_null($averageAcc) ? round($averageAcc * 100, 2) : 0.0;
          $unreadNotifications = $user->userNotifications()->whereNull('read_at')->count();
          return response()->json([
              'id' => $user->id,
              'name' => $user->name,
              'email' => $user->email,
              'phone_number' => $user->phone_number,
              'profile_photo_path' => $user->profile_photo_path,
              'created_at' => $user->created_at->toIso8601String(),
              'total_scans' => $totalScans,
              'average_accuracy' => $accuracy,
              'scans_today_count' => $user->scans()->where('created_at', '>=', $today)->count(),
              'scans_this_week_count' => $user->scans()->where('created_at', '>=', now()->startOfWeek())->count(),
              'unread_notifications_count' => $unreadNotifications,
          ]);
      }

      public function updateProfile(Request $request)
      {
          $user = $request->user();
          $updateData = [];
  
          if ($request->has('name')) {
              $request->validate(['name' => 'nullable|string|max:255']);
              $updateData['name'] = $request->name;
          }
  
          if ($request->has('phone_number')) {
             $request->validate(['phone_number' => 'nullable|string|max:20']);
             $updateData['phone_number'] = $request->phone_number ?: null;
         }
 
         if ($request->hasFile('profile_photo')) {
             $request->validate([
                 'profile_photo' => 'required|image|max:2048',
             ]);
 
             $disk = Storage::disk('public');
             $image = $request->file('profile_photo');
             $imageName = Str::uuid() . '.' . $image->getClientOriginalExtension();
             $disk->putFileAs('profile_photos', $image, $imageName);
             $imagePath = 'profile_photos/' . $imageName;
 
             // Delete old profile photo if exists
             if ($user->profile_photo_path && $disk->exists($user->profile_photo_path)) {
                 $disk->delete($user->profile_photo_path);
             }
 
             $updateData['profile_photo_path'] = $imagePath;
         }
 
          if (!empty($updateData)) {
              $user->update($updateData);
      }

          $today = now()->startOfDay();
          $totalScans = $user->scans()->count();
          $averageAcc = $user->scans()->whereNotNull('average_confidence')->avg('average_confidence');
          $accuracy = $totalScans > 0 && !is_null($averageAcc) ? round($averageAcc * 100, 2) : 0.0;
          $unreadNotifications = $user->userNotifications()->whereNull('read_at')->count();

          return response()->json([
              'id' => $user->id,
              'name' => $user->name,
              'email' => $user->email,
              'phone_number' => $user->phone_number,
              'profile_photo_path' => $user->profile_photo_path,
              'created_at' => $user->created_at->toIso8601String(),
              'total_scans' => $totalScans,
              'average_accuracy' => $accuracy,
              'scans_today_count' => $user->scans()->where('created_at', '>=', $today)->count(),
              'scans_this_week_count' => $user->scans()->where('created_at', '>=', now()->startOfWeek())->count(),
              'unread_notifications_count' => $unreadNotifications,
          ]);
      }

      public function uploadProfilePhoto(Request $request)
      {
          $user = $request->user();
          
          $request->validate([
              'profile_photo' => 'required|image|max:2048',
          ]);

          $disk = Storage::disk('public');
          $image = $request->file('profile_photo');
          $imageName = Str::uuid() . '.' . $image->getClientOriginalExtension();
          $disk->putFileAs('profile_photos', $image, $imageName);
          $imagePath = 'profile_photos/' . $imageName;

          // Delete old profile photo if exists
          if ($user->profile_photo_path && $disk->exists($user->profile_photo_path)) {
              $disk->delete($user->profile_photo_path);
          }

          $user->update([
              'profile_photo_path' => $imagePath,
          ]);

          $today = now()->startOfDay();
          $totalScans = $user->scans()->count();
          $averageAcc = $user->scans()->whereNotNull('average_confidence')->avg('average_confidence');
          $accuracy = $totalScans > 0 && !is_null($averageAcc) ? round($averageAcc * 100, 2) : 0.0;
          $unreadNotifications = $user->userNotifications()->whereNull('read_at')->count();

          return response()->json([
              'id' => $user->id,
              'name' => $user->name,
              'email' => $user->email,
              'phone_number' => $user->phone_number,
              'profile_photo_path' => $user->profile_photo_path,
              'created_at' => $user->created_at->toIso8601String(),
              'total_scans' => $totalScans,
              'average_accuracy' => $accuracy,
              'scans_today_count' => $user->scans()->where('created_at', '>=', $today)->count(),
              'scans_this_week_count' => $user->scans()->where('created_at', '>=', now()->startOfWeek())->count(),
              'unread_notifications_count' => $unreadNotifications,
          ]);
      }
}
