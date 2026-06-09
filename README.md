# Fruit Scan AI - What The Fruits?

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)

---

## Overview

Proyek ini dikembangkan sebagai tugas besar mata kuliah **Aplikasi Perangkat Bergerak (APB)** kelas IT-06-01 di Telkom University Surabaya. Aplikasi "What The Fruits?" memungkinkan pengguna mengidentifikasi jenis, tingkat kematangan, dan tingkat kesegaran buah secara real-time melalui kamera smartphone dengan dukungan tiga model MobileNetV2 yang berjalan secara paralel.

Sistem terdiri dari empat modul utama:
- **frontend/** — Aplikasi Flutter untuk antarmuka pengguna
- **backend/** — REST API Laravel dengan autentikasi Sanctum dan database PostgreSQL
- **ai-engine/** — FastAPI yang menjalankan tiga model AI secara paralel untuk klasifikasi buah
- **ai-training/** — Notebook Jupyter berisi proses training tiga model CNN dan tiga model KNN

---

## Identitas Tim Penyusun

| Nama | NIM |
|------|-----|
| Kadek Gandhi Wahyu Jaya Suastika | 1202230017 |
| Celia Jovita Carmel | 1202230007 |
| Aura Salsabilla Hestyastuti | 1202230016 |
| Rahmadinata Rizki Setiawan | 1202230052 |

---

## Tech Stack

| Teknologi | Fungsi |
|-----------|--------|
| **Flutter** 3.11+ | Framework frontend untuk membangun aplikasi Android |
| **Dart** 3.x | Bahasa pemrograman frontend |
| **Laravel** 11 | REST API backend dengan autentikasi Sanctum |
| **PostgreSQL** | Database relasional backend |
| **FastAPI** | REST API untuk inferensi tiga model AI |
| **Python** 3.12 | Bahasa pemrograman AI Engine dan training |
| **TensorFlow** 2.18 | Framework deep learning untuk tiga model MobileNetV2 |
| **Jupyter Notebook** | Media eksperimen dan training model |

---

## Arsitektur Sistem

```
  [Flutter App]               [Laravel API]                [FastAPI AI Engine]
  (Android HP)                (Port 8001)                  (Port 8000)
       |                           |                             |
       | --- POST /api/scans ----> |                             |
       |    (upload gambar)        |                             |
       |                           | --- POST /api/v1/predict -> |
       |                           |    (forward gambar)         |
       |                           |                             | --- model_variety.h5
       |                           |                             | --- model_ripeness.h5
       |                           |                             | --- model_freshness.h5
       |                           | <-- JSON prediction ------- |
       | <--- JSON response ------ |                             |
       |                           |                             |
       |                     [PostgreSQL]                        |
       |                     (users, scans,                      |
       |                      achievements,                     |
       |                      notifications)                    |
```

Detail model AI:
- **Variety Model** — Klasifikasi 3 kelas: apple, banana, orange (akurasi 97.48%)
- **Ripeness Model** — Klasifikasi 3 kelas: unripe, ripe, overripe (akurasi 92.67%)
- **Freshness Model** — Klasifikasi 2 kelas: fresh, unfresh (akurasi 97.92%)

---

## Quick Start

Satu laptop menjalankan server (backend dan ai-engine). Anggota lain cukup install APK.

### 1. Clone Repository

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
```

Edit `.env` — sesuaikan `MODEL_BASE_PATH`:
```
MODEL_BASE_PATH=../ai-training/models
```

Jalankan server:
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Verifikasi:
```bash
curl http://localhost:8000/api/v1/health
# Output: {"status":"healthy","models_loaded":{"variety":true,"ripeness":true,"freshness":true}}
```

### 3. Setup Backend (Laravel) — Port 8001

```bash
cd backend
cp .env.example .env
composer install
php artisan key:generate
```

Edit `.env` — sesuaikan konfigurasi database dan FastAPI:
```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=fruit_scan_db
DB_USERNAME=postgres
DB_PASSWORD=your_password

FASTAPI_URL=http://localhost:8000
```

PostgreSQL harus berjalan dan database `fruit_scan_db` harus dibuat terlebih dahulu:
```bash
psql -U postgres -c "CREATE DATABASE fruit_scan_db;"
```

Alternatif tanpa PostgreSQL — ubah `DB_CONNECTION=sqlite` di `.env` dan hapus konfigurasi DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD.

Jalankan migrasi dan seed:
```bash
php artisan migrate
php artisan tinker
```

Masukkan data achievements dan articles melalui `tinker`:
```php
Achievement::create(['name'=>'Apple Slayer','description'=>'5x scan apel','icon'=>'apple']);
Achievement::create(['name'=>'Banana Specialist','description'=>'5x scan pisang','icon'=>'banana']);
Achievement::create(['name'=>'Orange Connoisseur','description'=>'5x scan jeruk','icon'=>'orange']);
Achievement::create(['name'=>'Eagle Eye AI','description'=>'3x scan dengan confidence >= 90%','icon'=>'eagle']);
Achievement::create(['name'=>'Almost Comma','description'=>'3x scan buah tidak segar/overripe','icon'=>'warning']);
Achievement::create(['name'=>'Fruitarian Rookie','description'=>'10x total scan','icon'=>'star']);

Article::create(['tag'=>'apple','title'=>'Manfaat Apel untuk Kesehatan','content'=>'...','read_time'=>'3 min read']);
Article::create(['tag'=>'banana','title'=>'Manfaat Pisang untuk Kesehatan','content'=>'...','read_time'=>'3 min read']);
Article::create(['tag'=>'orange','title'=>'Manfaat Jeruk untuk Kesehatan','content'=>'...','read_time'=>'3 min read']);
```

Jalankan server Laravel:
```bash
php artisan serve --host=0.0.0.0 --port=8001
```

### 4. Build APK Flutter

```bash
cd frontend
flutter pub get
```

Edit file `lib/services/api_client.dart` — ubah `baseUrl`:
```dart
static String baseUrl = 'http://IP_LAPTOP_LARAVEL:8001';
```

Ganti `IP_LAPTOP_LARAVEL` dengan alamat IP laptop yang menjalankan Laravel (cek via `ifconfig`).

```bash
flutter build apk --debug
```

Hasil build: `frontend/build/app/outputs/flutter-apk/app-debug.apk`

### 5. Demo

1. Kirim file APK ke semua smartphone anggota tim
2. Setiap smartphone harus terhubung ke WiFi yang sama dengan laptop server
3. Buka aplikasi, lakukan registrasi akun baru, login, dan scan buah

---

## Panduan per Modul

| Modul | Perintah | Port |
|-------|----------|------|
| Frontend (Flutter) | `cd frontend && flutter run` | - |
| Backend (Laravel) | `cd backend && php artisan serve --host=0.0.0.0 --port=8001` | 8001 |
| AI Engine (FastAPI) | `cd ai-engine && .venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000` | 8000 |
| AI Training | `cd ai-training && jupyter notebook` | - |

## Catatan Penting

- File `.env` tidak tersimpan di git. Salin dari `.env.example` dan sesuaikan dengan konfigurasi masing-masing.
- Direktori `.venv/` tidak tersimpan di git. Buat ulang melalui `python3 -m venv .venv && pip install -r requirements.txt`.
- Dataset `master_dataset/` (24.053 gambar) tidak tersimpan di git. Hubungi pemilik repository untuk mendapatkan akses melalui Google Drive.
- Direktori `vendor/` (Laravel) tidak tersimpan di git. Jalankan `composer install` setelah clone.
- Semua perangkat harus berada dalam satu jaringan WiFi yang sama dengan laptop server.

---

## Struktur Repository

```
pecintaBuah/
├── frontend/           Aplikasi Flutter
├── backend/            API Laravel + Sanctum
├── ai-engine/          FastAPI inferensi AI
├── ai-training/        Notebook training dan model (.h5)
└── docs/               Dokumentasi dan laporan
```
