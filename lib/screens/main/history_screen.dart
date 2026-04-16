import 'package:flutter/material.dart';
import '../../core/theme.dart'; // Menggunakan AppColors dan AppTextStyles kita

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  // Data history disesuaikan menggunakan AppColors dari theme.dart
  final List<Map<String, dynamic>> _history = [
    {
      'name': 'Apple',
      'status': 'Ripe',
      'date': 'March 14, 2026',
      'image': 'assets/images/apple.jpg',
      'statusColor': AppColors.primary,
    },
    {
      'name': 'Banana',
      'status': 'Perfectly Ripe',
      'date': 'March 13, 2026',
      'image': 'assets/images/banana.jpg',
      'statusColor': AppColors.cyan,
    },
    {
      'name': 'Orange',
      'status': 'Ripe',
      'date': 'March 12, 2026',
      'image': 'assets/images/orange.jpg',
      'statusColor': AppColors.primary,
    },
    {
      'name': 'Strawberry',
      'status': 'Slightly Unripe',
      'date': 'March 11, 2026',
      'image': 'assets/images/strawberry.jpg',
      'statusColor': Colors.orange, // Menggunakan warna default orange
    },
    {
      'name': 'Grapes',
      'status': 'Ripe',
      'date': 'March 10, 2026',
      'image': 'assets/images/grapes.jpg',
      'statusColor': AppColors.primary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false, // Menghilangkan tombol back default
            title: Text(
              'Scan History',
              style: AppTextStyles.title.copyWith(fontSize: 20), // Konsisten dengan font Inter
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.inputBorder),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24), // Disesuaikan padding 24
              child: Column(
                children: [
                  _buildTotalScansCard(),
                  const SizedBox(height: 24),
                  ..._history.asMap().entries.map(
                        (e) => _buildHistoryItem(e.value, e.key),
                      ),
                  const SizedBox(height: 100), // Ruang untuk Bottom Nav Bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalScansCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient, // Menggunakan gradasi cyan-hijau
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
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
                style: AppTextStyles.bodyText.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '5',
                style: AppTextStyles.title.copyWith(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ],
          ),

          // Icon Apel di sebelah kanan
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Fallback warna transparan
              borderRadius: BorderRadius.circular(16),
              // Jika ingin memakai gambar apel (seperti kodemu sebelumnya), 
              // pastikan gambar ada. Jika belum ada, biarkan pakai icon sementara:
            ),
            child: const Icon(Icons.apple, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80), // Efek stagger (muncul bergantian)
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Gambar Buah
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
                // PERHATIAN: Jika error gambar tidak ditemukan, matikan baris image ini
                // dan ganti dengan Icon() sampai kamu punya file gambarnya.
                image: DecorationImage(
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                  // Fallback jika gambar gagal diload
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Label Status Ripe/Unripe
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: (item['statusColor'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item['status'],
                      style: AppTextStyles.subtitle.copyWith(
                        color: item['statusColor'] as Color,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Tanggal
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textSubtitle),
                      const SizedBox(width: 4),
                      Text(
                        item['date'],
                        style: AppTextStyles.subtitle.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: AppColors.textSubtitle, size: 20),
          ],
        ),
      ),
    );
  }
}