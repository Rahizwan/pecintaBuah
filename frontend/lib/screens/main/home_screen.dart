import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';
import '../../services/api_service.dart';
import '../../services/api_client.dart';
import '../../services/scan_service.dart';
import '../../models/app_user.dart';
import '../../models/scan_result.dart';
import '../../screens/main/result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  AppUser? _user;
  List<ScanResult> _recentScans = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app comes to foreground
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final user = await ApiService.getUser();
      List<ScanResult> recentScans = [];
      try {
        recentScans = await ScanService.getHistory();
      } catch (_) {
        recentScans = [];
      }

      if (mounted) {
        setState(() {
          _user = user;
          _recentScans = recentScans.take(2).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.emerald500))
                      : _error.isNotEmpty
                          ? _buildErrorState()
                          : _buildContent(context),
                ),
              ],
            ),
          ),
          _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gray50, Colors.white],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 200, right: -50,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                color: AppColors.emerald500.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile').then((_) => _loadData()),
                child: _buildHeaderAvatar(),
              ),
              const SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text("Welcome back,", style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1)),
                     Text(
                       _user != null && _user!.name.isNotEmpty
                           ? "Hello, ${_user!.name}! 👋"
                           : _user != null
                               ? "Hello, ${_user!.displayName}! 👋"
                               : "Loading...",
                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                       overflow: TextOverflow.ellipsis,
                     ),
                   ],
                 ),
               ),
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, '/notifications');
                  _loadData();
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.notifications_none_outlined, color: AppColors.primary),
                      if ((_user?.unreadNotificationsCount ?? 0) > 0)
                        Positioned(
                          top: 12, right: 12,
                          child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald500, shape: BoxShape.circle)),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScanCard(context),
          const SizedBox(height: 32),
          _buildQuickStats(),
          const SizedBox(height: 32),
          _buildAllTimeStats(),
          const SizedBox(height: 32),
          _buildRecentActivity(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(_error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.emerald500, AppColors.cyan500],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          const Text("Scan New Fruit", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const Text("Identify any fruit instantly with your AI camera", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.emerald500,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Start Scanning →", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final scansToday = _user?.scansTodayCount ?? 0;
    final todayScans = _recentScans.where((s) {
      return s.createdAt.day == DateTime.now().day &&
          s.createdAt.month == DateTime.now().month &&
          s.createdAt.year == DateTime.now().year;
    }).toList();
    final lastFruit = todayScans.isNotEmpty
        ? todayScans.first.fruitType
        : (_recentScans.isNotEmpty ? _recentScans.first.fruitType : "None yet");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Stats", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard("Scans Today", "$scansToday", Icons.bar_chart, AppColors.emerald500)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard("Last Fruit", lastFruit, Icons.apple, AppColors.cyan500)),
          ],
        ),
      ],
    );
  }

    Widget _buildAllTimeStats() {
      final totalScans = _user?.totalScans ?? 0;
      final accuracy = _user?.averageAccuracy ?? 0.0;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.emerald500.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.insights, color: AppColors.emerald500, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "All-Time Statistics",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  "Total Scans",
                  "$totalScans",
                  Icons.qr_code_scanner,
                  AppColors.emerald500,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  "Accuracy",
                  "${accuracy.toStringAsFixed(0)}%",
                  Icons.check_circle_outline,
                  AppColors.cyan500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.emerald500.withOpacity(0.1),
                  AppColors.cyan500.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.emerald500, AppColors.cyan500],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.analytics, color: Colors.white, size: 14),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Accuracy",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${accuracy.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emerald500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: accuracy / 100,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.emerald500, AppColors.cyan500],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: value.length > 5 ? 16 : 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    if (_recentScans.isEmpty) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                child: const Text("View All", style: TextStyle(color: AppColors.emerald500)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(Icons.history, size: 48, color: AppColors.muted.withOpacity(0.3)),
                const SizedBox(height: 8),
                const Text("No recent activity", style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/history'),
              child: const Text("View All", style: TextStyle(color: AppColors.emerald500)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ..._recentScans.map((scan) => _buildActivityItem(context, scan)),
      ],
    );
  }

  Widget _buildHeaderAvatar() {
    final photoPath = _user?.profilePhotoPath;
    if (photoPath != null && photoPath.isNotEmpty) {
      final url = '${ApiClient.baseUrl}/storage/$photoPath';
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(url, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildInitialsAvatar()),
      );
    }
    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.emerald500, Color(0xFF059669)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          _user != null ? _user!.name.substring(0, 1).toUpperCase() : "U",
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, ScanResult scan) {
    return GestureDetector(
      onTap: () {
        // Navigate to result screen with this scan result
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: scan),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: scan.imageUrl.isNotEmpty
                  ? Image.network(scan.imageUrl, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildSmallPlaceholder())
                  : _buildSmallPlaceholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scan.fruitType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${_formatTimeAgo(scan.createdAt)} · ${(scan.confidenceFruitType * 100).toStringAsFixed(0)}% match", style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  Widget _buildSmallPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: AppColors.gray100,
      child: const Icon(Icons.image, color: AppColors.muted, size: 20),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.home_filled, "HOME", true),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/history'),
                  child: _buildNavItem(Icons.history, "HISTORY", false),
                ),
              ],
            ),
          ),
        ),
      ),
    ).withFloatingCamera(context);
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppColors.emerald500 : AppColors.muted),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? AppColors.emerald500 : AppColors.muted)),
      ],
    );
  }
}

extension FloatingCameraButton on Widget {
  Widget withFloatingCamera(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        this,
        Positioned(
          bottom: 45,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/camera'),
            child: Container(
              width: 65, height: 65,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: AppColors.emerald500.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}
