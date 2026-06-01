<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ScanController;
use App\Http\Controllers\AchievementController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ArticleController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::put('/user', [AuthController::class, 'updateProfile']);
    Route::post('/user/profile-photo', [AuthController::class, 'uploadProfilePhoto']);

    Route::get('/scans', [ScanController::class, 'index']);
    Route::get('/scans/{scan}', [ScanController::class, 'show']);
    Route::post('/scans', [ScanController::class, 'store']);
    Route::post('/scans/preview', [ScanController::class, 'preview']);
    Route::post('/scans/confirm', [ScanController::class, 'confirm']);

    Route::get('/achievements', [AchievementController::class, 'index']);
    Route::post('/achievements/check', [AchievementController::class, 'check']);

    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::put('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::put('/notifications/{notification}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notifications/{notification}', [NotificationController::class, 'destroy']);

    Route::get('/articles', [ArticleController::class, 'index']);
    Route::get('/articles/{article}', [ArticleController::class, 'show']);
});
