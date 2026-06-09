# 🍎 Fruit Scan AI — What The Fruits?

Aplikasi identifikasi buah berbasis AI menggunakan kamera. Proyek Tugas Besar Mata Kuliah PCD, APB, & MTPP — Telkom University Surabaya.

## Arsitektur

```
Flutter App (Android)
      │  HTTP POST /api/scans
      ▼
Laravel API (Backend) ─── PostgreSQL
      │  HTTP POST /api/v1/predict
      ▼
FastAPI (AI Engine) ─── TensorFlow MobileNetV2
      ├── Variety Model  → apple / banana / orange  (97.48%)
      ├── Ripeness Model → unripe / ripe / overripe  (92.67%)
      └── Freshness Model→ fresh / unfresh  (97.92%)
```

## Struktur Repository

```
pecintaBuah/
├── frontend/           # Aplikasi Flutter (FE_PROJECT)
├── backend/            # API Laravel + Sanctum (BE_PROJECT)
├── ai-engine/          # FastAPI untuk inferensi AI (FAST_API_PROJECT)
├── ai-training/        # Notebook training + model (.h5) (AI_PROJECT)
└── docs/               # Dokumentasi + laporan (DOCS_PROJECT)
```

## ⚡ Quick Start (Demo Presentasi)

1 orang laptop jalanin server (backend + ai-engine), sisanya install APK.

### 1. Clone repositori

```bash
git clone https://github.com/Rahizwan/pecintaBuah.git
cd pecintaBuah
```

### 2. Setup AI Engine (FastAPI) — Port 8000

```bash
cd ai-engine
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env → sesuaikan MODEL_BASE_PATH = ../ai-training/models
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Verifikasi: `curl http://localhost:8000/api/v1/health`

### 3. Setup Backend (Laravel) — Port 8001

```bash
cd backend
cp .env.example .env
# Edit .env → isi DB_USERNAME dan DB_PASSWORD PostgreSQL kamu
# Pastikan FASTAPI_URL=http://localhost:8000
composer install
php artisan key:generate
php artisan migrate
php artisan serve --host=0.0.0.0 --port=8001
```

**Database:** Pastikan PostgreSQL aktif dan database `fruit_scan_db` sudah dibuat.
Alternatif: ubah `DB_CONNECTION=sqlite` di `.env` (tidak perlu PostgreSQL).

**Seed data:** Jalankan `php artisan tinker` untuk insert achievements & articles:
```php
Achievement::create(['name'=>'Apple Slayer','description'=>'5x scan apel','icon'=>'apple']);
Achievement::create(['name'=>'Banana Specialist','description'=>'5x scan pisang','icon'=>'banana']);
Achievement::create(['name'=>'Orange Connoisseur','description'=>'5x scan jeruk','icon'=>'orange']);
Achievement::create(['name'=>'Eagle Eye AI','description'=>'3x scan dengan confidence >= 90%','icon'=>'eagle']);
Achievement::create(['name'=>'Almost Comma','description'=>'3x scan buah tidak segar/overripe','icon'=>'warning']);
Achievement::create(['name'=>'Fruitarian Rookie','description'=>'10x total scan','icon'=>'star']);
```

### 4. Build APK Flutter

```bash
cd frontend
flutter pub get
```

Edit `lib/services/api_client.dart`:
```dart
static String baseUrl = 'http://IP_LAPTOP_LARAVEL:8001';
// Ganti IP_LAPTOP_LARAVEL dengan IP laptop yang menjalankan Laravel
```

```bash
flutter build apk --debug
# Hasil: build/app/outputs/flutter-apk/app-debug.apk
```

### 5. Install & Demo

- Kirim APK ke semua HP via Bluetooth/ShareIt
- Sambung HP ke WiFi yang sama dengan laptop
- Buka aplikasi → Register → Login → Scan buah 🎉

## 📦 Panduan per Modul

| Modul | Cara Running | Port |
|-------|-------------|------|
| **Frontend** (Flutter) | `cd frontend && flutter run` | — |
| **Backend** (Laravel) | `cd backend && php artisan serve --host=0.0.0.0 --port=8001` | `:8001` |
| **AI Engine** (FastAPI) | `cd ai-engine && uvicorn main:app --host 0.0.0.0 --port 8000` | `:8000` |
| **AI Training** | `cd ai-training && jupyter notebook` | — |

## ⚠️ Catatan

- `.env` files tidak ikut git — copy dari `.env.example` dan sesuaikan
- `.venv/` tidak ikut git — buat ulang via `python3 -m venv .venv && pip install -r requirements.txt`
- `master_dataset/` (24.053 gambar) tidak ikut git — minta dari pemilik repo via Google Drive
- `vendor/` (Laravel) tidak ikut git — jalankan `composer install`
- Semua perangkat harus **satu WiFi** dengan laptop server

## 👥 Anggota Kelompok

| Nama | NIM | Peran |
|------|-----|-------|
| Kadek Gandhi Wahyu Jaya Suastika | 1202230017 | Core Hardware & Information System |
| Celia Jovita Carmel | 1202230007 | Analytics & Data Persistence |
| Aura Salsabilla Hestyastuti | 1202230016 | Authentication & Data Metrics |
| Rahmadinata Rizki Setiawan | 1202230052 | Project Architecture & User Profile |
