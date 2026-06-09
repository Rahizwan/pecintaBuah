# PROJECT SUMMARY — Fruit Scan AI

> Dibuat: 31 Mei 2026
> IP WiFi Kos: `192.168.3.35`
> Root: `/Users/gandisuastika/Study/TEL-U/ACADEMIC/Semester-6/UNI-PROJECT/GAB_TUBES PCD_APB_ MTPP/dev`

---

## 1. Arsitektur

| Service | Port | Stack | Lokasi |
|---------|------|-------|--------|
| AI Engine (FastAPI) | `:8000` | Python 3.12, FastAPI, Uvicorn | `ai_api_fastapi/` |
| Backend (Laravel) | `:8001` | PHP, Laravel 11, Sanctum | `backend_laravel/` |
| Frontend (Flutter) | — | Flutter 3.11+, Dart | `front_end_ver/flutter_fruit_scan_w_ai/` |

Alur: Flutter → Laravel (`:8001`) → FastAPI (`:8000`)

---

## 2. Masalah yang Diselesaikan Hari Ini

### 2.1 Achievement Logic — Plural/Singular fruit_type Mismatch

**Problem:** AI model mengembalikan `"apples"`, `"oranges"`, `"bananas"` (plural) tapi `AchievementController` query pakai `"apple"`, `"orange"`, `"banana"` (singular) → achievement tidak terdeteksi.

**Fix — 2 langkah:**

**a) `ScanController.php:111-120`** — Method `normalizeFruitType()` baru:
```php
private function normalizeFruitType(string $fruitType): string
{
    $map = [
        'apples' => 'apple',
        'oranges' => 'orange',
        'bananas' => 'banana',
    ];
    return $map[strtolower($fruitType)] ?? strtolower($fruitType);
}
```

Dipanggil di 3 tempat:
- `preview()` (line 58)
- `confirm()` (line 92)
- `processImage()` (line 180)

**b) Migration `2026_05_31_060004_normalize_fruit_type_in_scans.php`** — Fix data existing:
```php
DB::table('scans')->where('fruit_type', 'apples')->update(['fruit_type' => 'apple']);
DB::table('scans')->where('fruit_type', 'oranges')->update(['fruit_type' => 'orange']);
DB::table('scans')->where('fruit_type', 'bananas')->update(['fruit_type' => 'banana']);
```

### 2.2 Login Error Messages — Spesifik

**AuthController.php:96-106** — Pemisahan error email vs password:
```php
if (!$user) {
    throw ValidationException::withMessages([
        'email' => ['Email belum terdaftar. Silakan lakukan registrasi terlebih dahulu.'],
    ]);
}
if (!Hash::check($validated['password'], $user->password)) {
    throw ValidationException::withMessages([
        'password' => ['Password yang dimasukkan salah.'],
    ]);
}
```

**AuthController.php:110-122** — Login return `new_notifications` dari DB:
```php
$newNotifications = UserNotification::where('user_id', $user->id)
    ->whereNull('read_at')
    ->whereIn('type', ['welcome', 'article_tip'])
    ->get()
    ->map(fn($n) => [...])
    ->toArray();
```

### 2.3 Auth Flow — Register → Login

**`auth_service.dart:16-24`** — `register()` tidak lagi menyimpan token/user. User harus login setelah register:
```dart
Future<Map<String, dynamic>> register(...) async {
  final data = await ApiService.register(...);
  return data; // token tidak disimpan
}
```

### 2.4 Notification Popup — Redesain Total

**`notification_popup.dart`** — Rewrite penuh:

| Fitur | Status |
|-------|--------|
| Slide-down animation (elasticOut) | ✅ |
| Dark mode support | ✅ |
| Confetti particle effect (achievement) | ✅ |
| Multiple notifications (>2 achievement → summary) | ✅ |
| Double-dismiss prevention (`_dismissed` flag) | ✅ |
| Root overlay (`OverlayState`, bukan `BuildContext`) | ✅ |
| Type `'error'` — `LucideIcons.octagonAlert` + `destructive50` | ✅ |
| Type `'success'` — `LucideIcons.circleCheck` + `emerald50` | ✅ |
| Auto-dismiss 5 detik | ✅ |
| Swipe to dismiss | ✅ |

**Key change:** `NotificationPopup.show()` now accepts `OverlayState` (not `BuildContext`). Caller captures overlay *before* navigation to guarantee popup survives route changes.

### 2.5 AppColors

**`app_colors.dart:9`** — Ditambah `destructive50`:
```dart
static const Color destructive50 = Color(0xFFFEF2F2);
```

### 2.6 Register Screen — Refactor

**`register_screen.dart`** — Perubahan:
- Google & GitHub buttons **dihapus**
- Validation error → `NotificationPopup(type:'error')` (bukan SnackBar)
- Success → navigasi ke `/login` + `NotificationPopup(type:'welcome')` "Selamat datang kembali…"
- `Scaffold(backgroundColor: Colors.transparent)` + `SizedBox.expand` untuk background

### 2.7 Login Screen — Refactor Total

**`login_screen.dart`** — Ditulis ulang:
- Validation error → `NotificationPopup(type:'error')`
- Sukses login:
  - Capture `Overlay.of(context, rootOverlay: true)` **sebelum** navigasi
  - Navigate ke `/home`
  - Jika `new_notifications` tidak kosong → `showMultiple()` (welcome + tips)
  - Jika kosong → `"Selamat Datang Kembali! Halo {name}…"` (returning user)
- Tombol "Forgot password?" dibiarkan (non-fungsi)
- Grafis, gradient, layout dipertahankan

### 2.8 Semua SnackBar → NotificationPopup

| File | SnackBar | Diganti jadi |
|------|----------|--------------|
| `result_screen.dart` | "Failed to save: $e" | `NotificationPopup(type:'error')` |
| `camera_screen.dart` | "Scan failed: …" + "Upload failed: …" | `NotificationPopup(type:'error')` (×2) |
| `notifications_screen.dart` | mark-read fail, delete fail, mark-all fail, article load fail | `NotificationPopup(type:'error')` (×4) |
| `profile_screen.dart` | update success, update fail, photo success, photo fail | sukses → `(type:'success')`, gagal → `(type:'error')` (×4) |

Total: 14 SnackBar → NotificationPopup

### 2.9 `flutter analyze` — Clean

86 info-level issues saja (withOpacity deprecated, use_build_context_synchronously, unnecessary_brace_in_string_interps, unnecessary_underscores).
**0 error, 0 warning.**

### 2.10 Icons Fix

`notification_popup.dart` — Icon errors fixed:
- `LucideIcons.alertCircle` (tidak ada) → `LucideIcons.octagonAlert`
- `LucideIcons.checkCircle` (tidak ada) → `LucideIcons.circleCheck`

---

## 3. Konfigurasi Jaringan

### 3.1 `api_client.dart` — Sebelum

```dart
static String get baseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8001'; // cuma emulator
  }
  return 'http://localhost:8001';
}
```

Import `dart:io` — digunakan hanya untuk `Platform.isAndroid`.

### 3.2 `api_client.dart` — Sesudah

```dart
static String baseUrl = 'http://192.168.3.35:8001'; // IP WiFi Kos
```

Import `dart:io` dihapus.

### 3.3 `AndroidManifest.xml`

```xml
<application
    android:usesCleartextTraffic="true"
    android:label="flutter_fruit_scan_w_ai"
    ...
```

---

## 4. Cara Start Server

### Manual

```bash
# FastAPI
cd "ai_api_fastapi"
.venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Laravel (terminal terpisah)
cd "backend_laravel"
php artisan serve --host=0.0.0.0 --port=8001
```

### Via Script

```bash
bash start_servers.sh
```

### Stop

```bash
pkill -f 'uvicorn main:app' && pkill -f 'artisan serve'
```

---

## 5. Build APK

```bash
cd "front_end_ver/flutter_fruit_scan_w_ai"
flutter build apk --debug
```

Hasil: `front_end_ver/flutter_fruit_scan_w_ai/build/app/outputs/flutter-apk/app-debug.apk`

### Untuk USB / Emulator

```bash
flutter run
```

---

## 6. Panduan Ganti WiFi

| Situasi | Actions |
|---------|---------|
| Pindah ke **WiFi Kampus** | `ifconfig \| grep "inet " \| grep -v 127.0.0.1` → edit `api_client.dart:5` → `flutter build apk --debug` → kirim ulang APK |
| Pindah kembali ke **WiFi Kos** | Balikin IP ke `192.168.3.35` → build ulang → kirim ulang |
| **Mau testing via USB tanpa WiFi** | `adb reverse tcp:8001 tcp:8001` + set `baseUrl = 'http://localhost:8001'` |

---

## 7. Yang Belum / Catatan

- **Hanya `--debug` build** — `--release` perlu setup keystore dulu
- **Forgot Password** — belum diimplementasikan (tombol non-fungsi)
- **withOpacity deprecation** — 60+ info, tidak mempengaruhi fungsi
- **Belum deploy ke cloud** — saat ini semua tergantung laptop + WiFi lokal

---

## 8. Alur Demo di Presentasi

1. Laptop nyala, sambung WiFi ruangan
2. Cek IP laptop → edit `api_client.dart`
3. `flutter build apk --debug` → kirim APK ke kelompok
4. `bash start_servers.sh` → FastAPI + Laravel jalan
5. Semua HP install APK, sambung WiFi yang sama
6. Buka app → registrasi → login → notifikasi muncul
