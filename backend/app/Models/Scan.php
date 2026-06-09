<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Scan extends Model
{
    protected $fillable = [
        'user_id',
        'image_path',
        'fruit_type',
        'ripeness_status',
        'freshness_level',
        'confidence_fruit_type',
        'confidence_ripeness_status',
        'confidence_freshness_level',
        'average_confidence',
    ];

    protected $casts = [
        'confidence_fruit_type' => 'float',
        'confidence_ripeness_status' => 'float',
        'confidence_freshness_level' => 'float',
        'average_confidence' => 'float',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
