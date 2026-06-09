<?php

namespace App\Console\Commands;

use App\Models\User;
use App\Models\Article;
use App\Models\UserNotification;
use Illuminate\Console\Command;

class SeedDefaultFruitTips extends Command
{
    protected $signature = 'notifications:seed-default-fruit-tips';
    protected $description = 'Seed default fruit tip notifications for all existing users';

    public function handle()
    {
        $articleTitles = [
            'Behind The Intelligence: How What The Fruits Analyzes Your Food',
            'The Big Three: Essential Health Facts of Apples, Bananas, and Oranges',
        ];

        $articles = Article::whereIn('title', $articleTitles)->get();
        if ($articles->count() < 2) {
            $this->error('Default articles not found. Run db:seed first.');
            return 1;
        }

        $users = User::all();
        $bar = $this->output->createProgressBar($users->count());
        $bar->start();

        $created = 0;
        foreach ($users as $user) {
            foreach ($articles as $article) {
                $exists = $user->userNotifications()
                    ->where('type', 'article_tip')
                    ->where('article_id', $article->id)
                    ->exists();

                if (!$exists) {
                    UserNotification::create([
                        'user_id' => $user->id,
                        'title' => 'Fruit Tips: ' . $article->title,
                        'body' => 'Klik untuk membaca artikel menarik ini.',
                        'type' => 'article_tip',
                        'article_id' => $article->id,
                    ]);
                    $created++;
                }
            }
            $bar->advance();
        }

        $bar->finish();
        $this->newLine();
        $this->info("Done! Created $created new notifications.");

        return 0;
    }
}
