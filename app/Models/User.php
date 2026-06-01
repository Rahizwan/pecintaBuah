<?php

namespace App\Models;

use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

#[Fillable(['name', 'email', 'password', 'phone_number', 'profile_photo_path'])]
#[Hidden(['password', 'remember_token'])]
class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function scans()
    {
        return $this->hasMany(Scan::class);
    }

    public function achievements()
    {
        return $this->belongsToMany(Achievement::class, 'user_achievements');
    }

    public function userAchievements()
    {
        return $this->hasMany(UserAchievement::class);
    }

    public function userNotifications()
    {
        return $this->hasMany(UserNotification::class);
    }
}
