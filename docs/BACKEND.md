# Backend — Laravel

## Tech Stack
- **PHP 8.3** / **Laravel 11**
- **Auth:** Laravel Sanctum (token-based)
- **Database:** PostgreSQL
- **Queue:** Database driver
- **Storage:** Local disk (`storage/app/public`)

## API Endpoints

### Auth
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login → returns token + user |
| POST | `/api/auth/logout` | Revoke current token |
| GET | `/api/user` | Get authenticated user profile |

### Scans
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/scan/preview` | Upload image → AI prediction |
| POST | `/api/scan/confirm` | Confirm & save scan result |
| GET | `/api/scans` | Get user's scan history |
| GET | `/api/scans/today` | Get today's scan count |

### Achievements
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/achievements` | Get all achievements + user progress |

### Notifications
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/notifications` | Get user notifications |
| PUT | `/api/notifications/{id}/read` | Mark one as read |
| PUT | `/api/notifications/read-all` | Mark all as read |
| DELETE | `/api/notifications/{id}` | Delete notification |

### Articles
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/articles` | Get all articles |
| GET | `/api/articles/{id}` | Get article detail |

## Models

- **User** — `id, name, email, password, phone_number, profile_photo_path`
- **Scan** — `id, user_id, fruit_type, confidence, average_confidence, image_path, is_correct`
- **Achievement** — `id, title, description, fruit_type, scan_count, icon`
- **UserAchievement** — `id, user_id, achievement_id, unlocked_at`
- **UserNotification** — `id, user_id, title, body, type, article_id, read_at`
- **Article** — `id, title, content, image_url`

## Serving

```bash
php artisan serve --host=0.0.0.0 --port=8001
```
