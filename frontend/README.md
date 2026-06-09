# What The Fruits? - Laporan Dokumentasi Artefak Tugas Besar 1

## Deskripsi Proyek
Proyek ini merupakan pengembangan aplikasi perangkat bergerak (Mobile Application) sebagai bagian dari Tugas Besar 1 mata kuliah **Aplikasi Perangkat Bergerak**. Aplikasi "What The Fruits?" dirancang untuk membantu pengguna mengidentifikasi jenis dan tingkat kematangan buah menggunakan teknologi AI.

**Institusi:** Telkom University Kampus Surabaya  
**Program Studi:** S1 Teknologi Informasi  
**Kelas:** IT06-01

---

## Anggota Kelompok
| Nama | NIM |
| :--- | :--- |
| Kadek Gandhi Wahyu Jaya Suastika | 1202230017 |
| Celia Jovita Carmel | 1202230007 |
| Aura Salsabilla Hestyastuti | 1202230016 |
| Rahmadinata Rizki Setiawan | 1202230052 |

---

## Tautan Repositori
Seluruh kode sumber proyek ini dapat diakses melalui tautan berikut:
👉 [GitHub Repository - pecintaBuah (revised-FE branch)](https://github.com/Rahizwan/pecintaBuah/tree/revised-FE)

---

## Daftar Kontribusi & Pembagian Tugas

### 1. Kadek Gandhi Wahyu Jaya Suastika (PIC: Core Hardware & Information System)
* **Implementasi Modul Kamera & Media Picker:** Bertanggung jawab penuh atas integrasi perangkat keras kamera menggunakan *camera plugin* dan fungsionalitas pengunggahan gambar dari galeri lokal (*media picker*) dengan penanganan memori yang optimal.
* **Pengembangan Fitur Edukasi (Notification & Article):** Merancang dan mengimplementasikan `NotificationScreen` dengan sistem *tab-switcher* dinamis serta `ArticleDetailScreen` yang interaktif untuk menyediakan konten edukasi buah kepada pengguna.

### 2. Aura Salsabilla Hestyastuti (PIC: Authentication & Data Metrics)
* **Pengembangan Antarmuka Autentikasi:** Menyusun kode antarmuka untuk halaman Login dan Register dengan fokus pada validasi *input* dan *User Experience* (UX) saat proses pendaftaran pengguna.
* **Implementasi Widget Metrik Akurasi:** Merancang *Dynamic Calculation Card* di halaman utama (Home) yang berfungsi mengkalkulasi dan memvisualisasikan tingkat akurasi sistem berdasarkan data historis pemindaian.

### 3. Rahmadinata Rizki Setiawan (PIC: Project Architecture & User Profile)
* **Arsitektur Proyek & Manajemen Repositori:** Melakukan inisialisasi repositori Git, mengatur struktur folder proyek mengikuti standar *clean architecture*, serta mengelola alur kerja kolaborasi di GitHub.
* **Navigasi & Personalisasi:** Mengembangkan halaman Home Dashboard sebagai pusat navigasi utama aplikasi (*Main Navigation*) dan merancang `ProfileScreen` untuk manajemen data personal pengguna.

### 4. Celia Jovita Carmel (PIC: Analytics & Data Persistence)
* **Visualisasi Hasil Pemindaian (Result Screen):** Mengembangkan antarmuka `ResultScreen` yang bertugas menampilkan metrik hasil analisis AI, informasi nutrisi, dan skor kematangan buah secara komprehensif.
* **Rekam Jejak Aktivitas (History Screen):** Bertanggung jawab atas pengembangan `HistoryScreen` yang memungkinkan pengguna untuk memantau kembali riwayat pemindaian buah yang pernah dilakukan sebelumnya.

---

## Panduan Instalasi dan Konfigurasi Sistem

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
