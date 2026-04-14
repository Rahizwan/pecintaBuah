import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import '../scan/camera_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Layar yang di-handle oleh Bottom App Bar (hanya index 0 dan 1)
  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(), // History sekarang ada di index 1 pada list ini
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // TOMBOL KAMERA MELAYANG DI TENGAH
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3), // Efek glow hijau
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Pindah ke halaman kamera (menimpa layar saat ini tanpa menghilangkan navigasi bawah tidak mungkin, 
            // jadi kita buka layar baru khusus kamera seperti aplikasi pada umumnya)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            );
          },
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // BOTTOM NAVIGATION BAR CUSTOM
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, // Jarak lengkungan dari tombol melayang
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab Kiri: HOME
              _buildTabItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'HOME',
                index: 0,
              ),
              
              const SizedBox(width: 48), // Ruang kosong di tengah untuk tombol kamera
              
              // Tab Kanan: HISTORY
              _buildTabItem(
                icon: Icons.history,
                activeIcon: Icons.history_rounded,
                label: 'HISTORY',
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol navigasi (Home & History)
  Widget _buildTabItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? AppColors.primary : AppColors.textSubtitle,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSubtitle,
            ),
          ),
        ],
      ),
    );
  }
}