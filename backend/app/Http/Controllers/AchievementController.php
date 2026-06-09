<?php

namespace App\Http\Controllers;

use App\Models\Achievement;
use App\Models\UserAchievement;
use App\Models\UserNotification;
use App\Models\Article;
use Illuminate\Http\Request;

class AchievementController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $earnedIds = $user->userAchievements()->pluck('achievement_id')->toArray();

        $achievements = Achievement::all()->map(function ($a) use ($earnedIds) {
            return [
                'id' => $a->id,
                'name' => $a->name,
                'description' => $a->description,
                'icon' => $a->icon,
                'earned' => in_array($a->id, $earnedIds),
            ];
        });

        return response()->json($achievements);
    }

    public function check(Request $request)
    {
        $user = $request->user();
        $newAchievements = [];

        // Check each achievement condition
        $achievements = Achievement::all();
        foreach ($achievements as $achievement) {
            if ($user->userAchievements()->where('achievement_id', $achievement->id)->exists()) {
                continue; // Already earned
            }

            $earned = false;
            switch ($achievement->name) {
                case 'Apple Slayer':
                    $earned = $user->scans()->where('fruit_type', 'apple')->count() >= 5;
                    break;

                case 'Banana Specialist':
                    $earned = $user->scans()->where('fruit_type', 'banana')->count() >= 5;
                    break;

                case 'Orange Connoisseur':
                    $earned = $user->scans()->where('fruit_type', 'orange')->count() >= 5;
                    break;

                case 'Eagle Eye AI':
                    $totalScans = $user->scans()->count();
                    $avgAcc = $user->scans()->whereNotNull('average_confidence')->avg('average_confidence');
                    $earned = $totalScans >= 3 && !is_null($avgAcc) && $avgAcc >= 0.90;
                    break;

                case 'Almost Comma':
                    $earned = $user->scans()
                        ->where(function ($q) {
                            $q->where('freshness_level', 'unfresh')
                              ->orWhere('ripeness_status', 'overripe');
                        })
                        ->count() >= 3;
                    break;

                case 'Fruitarian Rookie':
                    $earned = $user->scans()->count() >= 10;
                    break;
            }

            if ($earned) {
                UserAchievement::create([
                    'user_id' => $user->id,
                    'achievement_id' => $achievement->id,
                ]);

                // Create achievement notification
                $notif = UserNotification::create([
                    'user_id' => $user->id,
                    'title' => $this->getAchievementTitle($achievement->name),
                    'body' => $this->getAchievementBody($achievement->name),
                    'type' => 'achievement',
                ]);

                $newNotifs[] = [
                    'id' => $notif->id,
                    'title' => $notif->title,
                    'body' => $notif->body,
                    'type' => 'achievement',
                ];

                $newAchievements[] = [
                    'id' => $achievement->id,
                    'name' => $achievement->name,
                ];

                // Find associated article for this achievement
                $article = $this->getArticleForAchievement($achievement->name);
                if ($article) {
                    $tipNotif = UserNotification::create([
                        'user_id' => $user->id,
                        'title' => 'Fruit Tips: ' . $article->title,
                        'body' => 'Klik untuk membaca artikel terkait prestasi ini.',
                        'type' => 'article_tip',
                        'article_id' => $article->id,
                    ]);

                    $newNotifs[] = [
                        'id' => $tipNotif->id,
                        'title' => $tipNotif->title,
                        'body' => $tipNotif->body,
                        'type' => 'article_tip',
                        'article_id' => $article->id,
                    ];
                }
            }
        }

        return response()->json([
            'new_achievements' => $newAchievements,
            'new_notifications' => $newNotifs ?? [],
        ]);
    }

    private function getAchievementTitle(string $name): string
    {
        return match ($name) {
            'Apple Slayer' => 'Selamat! Kamu mendapatkan gelar Apple Slayer!',
            'Banana Specialist' => 'Hebat! Lencana Banana Specialist kini menjadi milikmu!',
            'Orange Connoisseur' => 'Luar biasa! Gelar Orange Connoisseur resmi diraih!',
            'Eagle Eye AI' => 'Mata Elang! Prestasi Eagle Eye AI berhasil diraih!',
            'Almost Comma' => 'Waspada! Lencana Almost Comma telah diaktifkan!',
            'Fruitarian Rookie' => 'Selamat Langkah Awal! Gelar Fruitarian Rookie diraih!',
            default => 'Prestasi baru telah diraih!',
        };
    }

    private function getAchievementBody(string $name): string
    {
        return match ($name) {
            'Apple Slayer' => 'Kamu sering mendeteksi kesegaran buah Apel! Teruskan kebiasaan sehatmu.',
            'Banana Specialist' => 'Kamu telah melacak kematangan berbagai pisang dengan baik!',
            'Orange Connoisseur' => 'Kontribusimu meneliti kesegaran buah Jeruk sangat luar biasa!',
            'Eagle Eye AI' => 'Kualitas fotomu sangat ideal sehingga AI mendeteksi dengan keyakinan tinggi!',
            'Almost Comma' => 'Kamu berhasil menyelamatkan diri dari konsumsi buah yang sudah tidak segar!',
            'Fruitarian Rookie' => 'Kamu telah mendeteksi total 10 buah di aplikasi ini!',
            default => 'Teruskan semangat scanning buah!',
        };
    }

    private function getArticleForAchievement(string $name): ?Article
    {
        $articleTitle = match ($name) {
            'Apple Slayer' => 'The Pectin Power: How an Apple a Day Shield Your Heart',
            'Banana Specialist' => 'The Potassium Engine: Bananas as Your Ultimate Natural Recovery Fuel',
            'Orange Connoisseur' => 'Beyond Vitamin C: The Multi-Layered Defense of Citrus Fruits',
            'Eagle Eye AI' => 'Perfect Lighting and Framing: The Computer Vision Guide to Precise Fruit Scanning',
            'Almost Comma' => 'The Danger of Overripe: Understanding Chlorophyll Degradation and Food Safety',
            'Fruitarian Rookie' => 'The 10-Scan Milestone: Building Sustainable Healthy Habits Through Gamification',
            default => null,
        };

        if (!$articleTitle) return null;

        return Article::where('title', $articleTitle)->first();
    }
}
