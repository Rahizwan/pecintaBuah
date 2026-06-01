# Fruit Scan AI

A mobile application for fruit detection and classification using AI, built with Flutter, Laravel, and FastAPI.

## Architecture

```
Flutter App  ──HTTP──>  Laravel API (:8001)  ──HTTP──>  FastAPI AI (:8000)
                              │
                              └── PostgreSQL Database
```

## Components

| Module | Tech | Branch |
|--------|------|--------|
| Frontend | Flutter 3.11+ | `FE_PROJECT` |
| Backend API | Laravel 11, Sanctum | `BE_PROJECT` |
| AI Inference | FastAPI, Python 3.12 | `FAST_API_PROJECT` |
| Documentation | Markdown | `DOCS_PROJECT` (this branch) |

## Quick Start

1. Start FastAPI: `.venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload`
2. Start Laravel: `php artisan serve --host=0.0.0.0 --port=8001`
3. Build APK: `flutter build apk --debug`
4. Install APK on phone (same WiFi as laptop)

See [guide_start_server.md](guide_start_server.md) for detailed instructions.
