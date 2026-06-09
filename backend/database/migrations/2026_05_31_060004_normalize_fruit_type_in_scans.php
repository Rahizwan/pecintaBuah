<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('scans')->where('fruit_type', 'apples')->update(['fruit_type' => 'apple']);
        DB::table('scans')->where('fruit_type', 'oranges')->update(['fruit_type' => 'orange']);
        DB::table('scans')->where('fruit_type', 'bananas')->update(['fruit_type' => 'banana']);
    }

    public function down(): void
    {
    }
};
