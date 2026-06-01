<?php

namespace Database\Seeders;

use App\Models\Achievement;
use Illuminate\Database\Seeder;

class AchievementSeeder extends Seeder
{
    public function run(): void
    {
        $achievements = [
            [
                'name' => 'Apple Slayer',
                'description' => 'Berhasil men-scan buah Apel sebanyak 5 kali',
                'icon' => 'apple',
            ],
            [
                'name' => 'Banana Specialist',
                'description' => 'Berhasil men-scan buah Pisang sebanyak 5 kali',
                'icon' => 'banana',
            ],
            [
                'name' => 'Orange Connoisseur',
                'description' => 'Berhasil men-scan buah Jeruk sebanyak 5 kali',
                'icon' => 'orange',
            ],
            [
                'name' => 'Eagle Eye AI',
                'description' => 'Mencapai rata-rata akurasi 90% dengan minimal 3 scan',
                'icon' => 'eye',
            ],
            [
                'name' => 'Almost Comma',
                'description' => 'Mendeteksi buah busuk atau terlalu matang sebanyak 3 kali',
                'icon' => 'alert-triangle',
            ],
            [
                'name' => 'Fruitarian Rookie',
                'description' => 'Mencapai total 10 kali pemindaian buah',
                'icon' => 'leaf',
            ],
        ];

        foreach ($achievements as $a) {
            Achievement::firstOrCreate(['name' => $a['name']], $a);
        }
    }
}
