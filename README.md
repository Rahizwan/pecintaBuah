## Deskripsi Proyek
What The Fruits? adalah sistem pemindaian buah berbasis mobile yang mengintegrasikan Flutter untuk antarmuka pengguna, Laravel sebagai penyedia layanan API, serta FastAPI untuk pemrosesan citra menggunakan model Convolutional Neural Network (CNN). Proyek ini dirancang untuk memberikan analisis presisi mengenai jenis buah, tingkat kematangan, dan kadar kesegaran secara real-time.

Dokumentasi ini mencatat perkembangan fase pengembangan antarmuka (Frontend) dan memberikan panduan teknis bagi pengembang untuk melakukan replikasi lingkungan kerja.

---

## 1. Status Pengembangan Antarmuka (Frontend Progress)
Seluruh modul antarmuka telah diselesaikan dengan mengimplementasikan prinsip Clean Code, penggunaan High-DPI Vector Icons (Lucide Icons), serta efek visual Glassmorphism.

### Daftar Layar dan Fungsionalitas
* **Layar Splash & Loading**: Mengelola inisialisasi awal aplikasi dan transisi data sebelum memasuki modul autentikasi.
* **Modul Autentikasi (Login & Registrasi)**: Implementasi antarmuka untuk manajemen akses pengguna dengan validasi visual yang terstandarisasi.
* **Dashboard Utama (Home)**: Pusat kendali aplikasi yang mencakup Quick Stats, kartu navigasi pemindaian, dan daftar aktivitas terbaru.
* **AI Camera Scanner**: Antarmuka pengambilan gambar tingkat lanjut yang dilengkapi dengan:
    * Animasi scanning overlay untuk indikator proses AI.
    * Fungsi peralihan kamera (Flip Camera) untuk fleksibilitas penggunaan.
    * Bingkai fokus (Focus Frame) adaptif.
* **Layar Hasil Analisis (Result)**: Menampilkan data keluaran AI secara kuantitatif melalui persentase untuk indikator kematangan (Ripeness) dan tingkat kesegaran (Freshness).
* **Riwayat Pemindaian (History)**: Manajemen data hasil pemindaian sebelumnya yang dilengkapi dengan label status dinamis.
* **Pusat Notifikasi**: Mengelola pemberitahuan sistem, informasi pembaruan model AI, dan log aktivitas.
* **Profil Pengguna**: Modul pengaturan akun dengan fitur Toggle Edit Mode untuk pembaruan informasi personal secara dinamis.

---

## 2. Panduan Instalasi dan Konfigurasi Sistem

### Prasyarat Sistem
Untuk memastikan aplikasi berjalan optimal, perangkat pengembang harus memenuhi spesifikasi berikut:
* **Flutter SDK**: Minimum versi 3.11.0.
* **Bahasa Pemrograman**: Dart 3.x.
* **Platform Target**: Android API Level 35 (Android 15+) atau iOS versi terbaru.
* **Perangkat Keras**: Sangat disarankan menggunakan perangkat fisik untuk pengujian fitur kamera.

### Langkah-Langkah Menjalankan Proyek
1.  **Kloning Repositori**:
    Akses repositori melalui terminal dan pindah ke cabang revisi frontend:
    ```bash
    git clone [https://github.com/Rahizwan/pecintaBuah.git](https://github.com/Rahizwan/pecintaBuah.git)
    cd pecintaBuah
    git checkout revised-FE
    ```

2.  **Instalasi Dependensi**:
    Unduh seluruh library yang diperlukan melalui Flutter Pub:
    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Perizinan Perangkat**:
    Pastikan file `android/app/src/main/AndroidManifest.xml` telah menyertakan deklarasi perizinan berikut untuk akses hardware:
    * `android.permission.CAMERA`
    * `android.permission.READ_MEDIA_IMAGES`
    * `android.permission.READ_EXTERNAL_STORAGE` (untuk kompatibilitas API < 33)

4.  **Eksekusi Aplikasi**:
    Pastikan perangkat fisik terhubung melalui USB Debugging, kemudian jalankan perintah:
    ```bash
    flutter run
    ```

---

## 3. Rencana Pengembangan Selanjutnya (Future Roadmap)

Pengembangan akan dilanjutkan pada fase integrasi logika dan layanan backend:

1.  **Integrasi Layanan Laravel (Backend API)**:
    * Implementasi JSON Web Token (JWT) untuk sistem autentikasi.
    * Sinkronisasi database PostgreSQL untuk manajemen riwayat pemindaian dan profil pengguna.
2.  **Integrasi Layanan FastAPI (AI Engine)**:
    * Koneksi antara aplikasi mobile dengan server FastAPI melalui protokol HTTP (package: http).
    * Pengiriman data citra mentah (raw image) untuk diproses oleh model CNN.
3.  **Implementasi Logika Kamera Real-Time**:
    * Transisi dari simulasi UI ke pengambilan gambar nyata.
    * Manajemen penyimpanan file gambar sementara (Cache) sebelum proses unggah.

---

**Disusun oleh Tukang Buah Naik Haji:**
1. Kadek Gandhi Wahyu Jaya Suastika
2. Celia Jovita Carmel 
3. Aura Salsabilla Hestyastuti 
4. Rahmadinata Rizki Setiawan
