<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ScanResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'image_url' => '/storage/' . $this->image_path,
            'fruit_type' => $this->fruit_type,
            'ripeness_status' => $this->ripeness_status,
            'freshness_level' => $this->freshness_level,
            'confidence' => [
                'fruit_type' => $this->confidence_fruit_type,
                'ripeness_status' => $this->confidence_ripeness_status,
                'freshness_level' => $this->confidence_freshness_level,
            ],
            'created_at' => $this->created_at->toIso8601String(),
        ];
    }
}
