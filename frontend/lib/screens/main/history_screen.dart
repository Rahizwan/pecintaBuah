import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';
import '../../services/scan_service.dart';
import '../../models/scan_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScanResult>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = ScanService.getHistory();
  }

  Future<void> _refresh() {
    setState(() {
      _historyFuture = ScanService.getHistory();
    });
    return _historyFuture;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: FutureBuilder<List<ScanResult>>(
                    future: _historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.emerald500));
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: AppColors.muted),
                              const SizedBox(height: 16),
                              Text('Failed to load history'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final history = snapshot.data ?? [];

                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSummaryCards(history),
                              const SizedBox(height: 32),
                              const Text(
                                "Recent Scans",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),

                              if (history.isEmpty)
                                _buildEmptyState()
                              else
                                ...history.map((item) => _buildHistoryCard(context, item)),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      );
                    },
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

  Widget _buildSummaryCards(List<ScanResult> historyList) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final thisWeekCount = historyList.where((s) => s.createdAt.isAfter(weekStart)).length;
    return Row(
      children: [
        Expanded(
          child: _buildGradientCard("Total Scans", "${historyList.length}", LucideIcons.apple),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildWhiteCard("This Week", "$thisWeekCount", LucideIcons.trendingUp),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(LucideIcons.scan, size: 64, color: AppColors.muted.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text("No scans yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.muted)),
          const SizedBox(height: 8),
          const Text("Start scanning fruits to see your history here", style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ScanResult item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/result', arguments: item),
      child: Container(
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
              child: item.imageUrl.isNotEmpty
                  ? Image.network(item.imageUrl, width: 70, height: 70, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage())
                  : _buildPlaceholderImage(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.fruitType.isNotEmpty ? item.fruitType : "Unknown", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                  const SizedBox(height: 6),
                  _buildBadge(item.ripenessStatus),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 12, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Text(DateFormat('MMMM d, y').format(item.createdAt), style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 70,
      height: 70,
      color: AppColors.gray100,
      child: const Icon(Icons.image, color: AppColors.muted, size: 24),
    );
  }

  Widget _buildBadge(String status) {
    List<Color> colors;
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == "ripe") {
      colors = [AppColors.emerald500, AppColors.cyan500];
    } else if (lowerStatus.contains("unripe")) {
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
        status.isNotEmpty ? status : "Unknown",
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
