<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
      /**
       * Run the migrations.
       */
      public function up(): void
      {
          Schema::table('scans', function (Blueprint $table) {
              $table->decimal('average_confidence', 5, 4)->nullable()->after('confidence_freshness_level');
          });

          // Compute average confidence from existing confidence columns
          \DB::table('scans')->update([
              'average_confidence' => \DB::raw('(confidence_fruit_type + confidence_ripeness_status + confidence_freshness_level) / 3')
          ]);

          // Remove the old is_correct column
          Schema::table('scans', function (Blueprint $table) {
              $table->dropColumn('is_correct');
          });
      }

      /**
       * Reverse the migrations.
       */
      public function down(): void
      {
          Schema::table('scans', function (Blueprint $table) {
              $table->boolean('is_correct')->default(false)->after('confidence_freshness_level');
              $table->dropColumn('average_confidence');
          });
      }
};
