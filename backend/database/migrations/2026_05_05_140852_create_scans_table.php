<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('scans', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('image_path');
            $table->string('fruit_type');
            $table->string('ripeness_status');
            $table->string('freshness_level');
            $table->decimal('confidence_fruit_type', 5, 4);
            $table->decimal('confidence_ripeness_status', 5, 4);
            $table->decimal('confidence_freshness_level', 5, 4);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('scans');
    }
};
