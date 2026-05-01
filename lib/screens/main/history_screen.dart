import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import '../../core/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> historyData = [
      {
        "name": "Apple",
        "ripeness": "Ripe",
        "status": "ripe",
        "date": "March 14, 2026",
        "image": "https://images.unsplash.com/photo-1757283961570-f6b9019753e9?w=400"
      },
      {
        "name": "Banana",
        "ripeness": "Perfectly Ripe",
        "status": "ripe",
        "date": "March 13, 2026",
        "image": "https://images.unsplash.com/photo-1623810836868-057b23aef3aa?w=400"
      },
      {
        "name": "Orange",
        "ripeness": "Ripe",
        "status": "ripe",
        "date": "March 12, 2026",
        "image": "https://images.unsplash.com/photo-1663002976076-de02deea5fbe?w=400"
      },
      {
        "name": "Strawberry",
        "ripeness": "Slightly Unripe",
        "status": "unripe",
        "date": "March 11, 2026",
        "image": "https://images.unsplash.com/photo-1710528184650-fc75ae862c13?w=400"
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gray50, Colors.white, AppColors.emerald50],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
              
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCards(historyData.length),
                        const SizedBox(height: 32),
                        const Text(
                          "Recent Scans",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        
                        // Loop History Items
                        ...historyData.map((item) => _buildHistoryCard(context, item)),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.arrowLeft, size: 20, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                "Scan History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(int total) {
    return Row(
      children: [
        Expanded(
          child: _buildGradientCard("Total Scans", "$total", LucideIcons.apple),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildWhiteCard("This Week", "12", LucideIcons.trendingUp),
        ),
      ],
    );
  }

  Widget _buildGradientCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.emerald500, AppColors.cyan500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWhiteCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.emerald500.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.emerald500, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label.toUpperCase(), style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(item['image']!, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 6),
                _buildBadge(item['ripeness']!, item['status']!),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 12, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(item['date']!, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, String status) {
    List<Color> colors;
    if (status == "ripe") {
      colors = [AppColors.emerald500, AppColors.cyan500];
    } else if (status == "unripe") {
      colors = [const Color(0xFFFACC15), const Color(0xFFFB923C)];
    } else {
      colors = [const Color(0xFFF87171), const Color(0xFFFB923C)];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}