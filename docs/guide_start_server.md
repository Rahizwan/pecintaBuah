# Panduan Menjalankan Server & Ganti IP

## Root Folder
```
/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev
```

---

## 1. Start FastAPI (AI Engine) — Port 8000

```bash
cd "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev/ai_api_fastapi"
.venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

## 2. Start Laravel (Backend) — Port 8001

```bash
cd "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev/backend_laravel"
php artisan serve --host=0.0.0.0 --port=8001
```

## 3. Start Keduanya Sekaligus (via Script)

```bash
bash start_servers.sh
```

Script `start_servers.sh` ada di:
```
/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev/start_servers.sh
```

## 4. Matikan Server

```bash
pkill -f 'uvicorn main:app' && pkill -f 'artisan serve'
```

---

## 5. Ganti IP untuk WiFi Berbeda

### File yang diedit
```
front_end_ver/flutter_fruit_scan_w_ai/lib/services/api_client.dart
```
Baris 5 — `static String baseUrl = 'http://...:8001';`

### Cek IP Laptop

```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

### Contoh IP

| Lokasi | IP (contoh) |
|--------|------------|
| WiFi Kos | `http://192.168.3.35:8001` |
| WiFi Kampus | `http://192.168.x.x:8001` (ganti sesuai hasil `ifconfig`) |

### Setelah ganti IP → Build Ulang APK

```bash
cd "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev/front_end_ver/flutter_fruit_scan_w_ai"
flutter build apk --debug
```

File APK hasil build:
```
front_end_ver/flutter_fruit_scan_w_ai/build/app/outputs/flutter-apk/app-debug.apk
```

---

## 6. Tes di Emulator / HP via USB

```bash
cd "/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev/front_end_ver/flutter_fruit_scan_w_ai"
flutter run
```

---

## Ringkasan Alur Demo

1. Laptop nyala, sambung WiFi
2. Cek IP: `ifconfig | grep "inet " | grep -v 127.0.0.1`
3. Edit `api_client.dart` → isi IP terbaru (kalau pindah WiFi)
4. `flutter build apk --debug` → kirim APK ke teman
5. `bash start_servers.sh` → jalanin FastAPI + Laravel
6. Semua HP install APK & buka app (harus satu WiFi dengan laptop)
