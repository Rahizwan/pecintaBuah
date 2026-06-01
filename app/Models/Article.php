<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Article extends Model
{
    protected $fillable = [
        'tag',
        'title',
        'content',
        'read_time',
    ];

    public function notifications()
    {
        return $this->hasMany(UserNotification::class);
    }
}
