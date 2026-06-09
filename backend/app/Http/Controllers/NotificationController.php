<?php

namespace App\Http\Controllers;

use App\Models\UserNotification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $notifications = $request->user()->userNotifications()
            ->with('article:id,tag,title,read_time')
            ->orderByRaw('read_at is null desc')
            ->latest()
            ->get()
            ->map(function ($n) {
                return [
                    'id' => $n->id,
                    'title' => $n->title,
                    'body' => $n->body,
                    'type' => $n->type,
                    'article_id' => $n->article_id,
                    'article' => $n->article ? [
                        'id' => $n->article->id,
                        'tag' => $n->article->tag,
                        'title' => $n->article->title,
                        'read_time' => $n->article->read_time,
                    ] : null,
                    'read_at' => $n->read_at?->toIso8601String(),
                    'created_at' => $n->created_at->toIso8601String(),
                ];
            });

        return response()->json($notifications);
    }

    public function markAsRead(Request $request, UserNotification $notification)
    {
        if ($notification->user_id !== $request->user()->id) {
            abort(403, 'Unauthorized');
        }

        $notification->update(['read_at' => now()]);

        return response()->json(['message' => 'Marked as read']);
    }

    public function markAllAsRead(Request $request)
    {
        $request->user()->userNotifications()
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        return response()->json(['message' => 'All marked as read']);
    }

    public function destroy(Request $request, UserNotification $notification)
    {
        if ($notification->user_id !== $request->user()->id) {
            abort(403, 'Unauthorized');
        }

        if ($notification->type === 'article_tip') {
            abort(403, 'Fruit tips notifications cannot be deleted');
        }

        $notification->delete();

        return response()->json(['message' => 'Notification deleted']);
    }
}
