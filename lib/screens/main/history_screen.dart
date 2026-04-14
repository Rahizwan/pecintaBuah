import 'package:flutter/material.dart';
import '../../core/theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // -- HEADER (App Bar) --
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Scan History',
          style: AppTextStyles.title.copyWith(fontSize: 20),
        ),
        centerTitle: false,
      ),
      
      // -- ISI KONTEN --
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. KARTU TOTAL SCANS (Gradient)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Scans',
                        style: AppTextStyles.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '5',
                        style: AppTextStyles.title.copyWith(color: Colors.white, fontSize: 36),
                      ),
                    ],
                  ),
                  // Icon Apel dengan background putih transparan
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.apple, color: Colors.white, size: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // 2. DAFTAR RIWAYAT BUAH
            // Kita gunakan fungsi _buildHistoryItem agar kodenya tidak panjang dan berulang
            _buildHistoryItem('Apple', 'Ripe', 'March 14, 2026', Icons.apple, AppColors.cyan),
            _buildHistoryItem('Banana', 'Perfectly Ripe', 'March 13, 2026', Icons.line_weight, AppColors.cyan),
            _buildHistoryItem('Orange', 'Ripe', 'March 12, 2026', Icons.sports_volleyball, AppColors.cyan),
            _buildHistoryItem('Strawberry', 'Slightly Unripe', 'March 11, 2026', Icons.lens, Colors.orange),
            _buildHistoryItem('Grapes', 'Ripe', 'March 10, 2026', Icons.circle, AppColors.cyan),
            
            // Ruang kosong di bawah agar item terakhir tidak tertutup Bottom Navigation Bar
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }

  // --- FUNGSI CETAKAN UNTUK LIST ITEM HISTORY ---
  Widget _buildHistoryItem(String name, String status, String date, IconData icon, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          // Gambar / Icon Buah
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 36),
          ),
          const SizedBox(width: 16),
          
          // Informasi Tengah (Nama, Label Status, Tanggal)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w600, fontSize: 16)
                ),
                const SizedBox(height: 6),
                
                // Label Ripe / Unripe berbentuk "Pill" (Kapsul)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20), // Membuatnya bulat seperti kapsul
                  ),
                  child: Text(
                    status,
                    style: AppTextStyles.subtitle.copyWith(
                      color: Colors.white, 
                      fontSize: 12, 
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Tanggal dengan icon kalender kecil
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSubtitle),
                    const SizedBox(width: 6),
                    Text(
                      date, 
                      style: AppTextStyles.subtitle.copyWith(fontSize: 12)
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Icon Panah Kanan
          const Icon(Icons.arrow_forward_ios, color: AppColors.inputBorder, size: 16),
        ],
      ),
    );
  }
}