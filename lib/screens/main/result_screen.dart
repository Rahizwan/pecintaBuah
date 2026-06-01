import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/app_colors.dart';
import '../../models/scan_result.dart';
import '../../services/scan_service.dart';
import '../../widgets/notification_popup.dart';

class ResultScreen extends StatefulWidget {
  final ScanResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
   bool _isSaving = false;

  Future<void> _saveAndNavigate(String route) async {
    if (widget.result.isPreview) {
      setState(() => _isSaving = true);
      try {
        final result = await ScanService.confirmScan(widget.result.toConfirmJson());
        final newNotifications = result['new_notifications'] as List<dynamic>? ?? [];

        if (mounted) {
          final overlay = Overlay.of(context, rootOverlay: true);
          Navigator.pushNamedAndRemoveUntil(
            context,
            route == '/camera' ? '/camera' : '/home',
            (r) => r == '/home',
          );
          if (newNotifications.isNotEmpty) {
            NotificationPopup.showMultiple(
              overlay: overlay,
              notifications: newNotifications.cast<Map<String, dynamic>>(),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          NotificationPopup.show(
            overlay: Overlay.of(context, rootOverlay: true),
            title: 'Gagal Menyimpan',
            body: 'Gagal menyimpan scan: ${e.toString().replaceFirst('Exception: ', '')}',
            type: 'error',
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    } else {
      Navigator.pushNamed(context, route);
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildScannedImage(),
                        const SizedBox(height: 24),
                        _buildFruitTypeCard(),
                        const SizedBox(height: 16),
                        _buildRipenessCard(),
                        const SizedBox(height: 16),
                        _buildFreshnessCard(),
                        const SizedBox(height: 32),
                        _buildActionButtons(context),
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

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gray50, Colors.white, Color(0xFFECFDF5)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 100, right: -30,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(color: AppColors.emerald500.withOpacity(0.05), shape: BoxShape.circle),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Scan Result", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(LucideIcons.x, size: 20, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannedImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.network(
              widget.result.imageUrl.isNotEmpty ? widget.result.imageUrl : "https://images.unsplash.com/photo-1757283961570-f6b9019753e9?w=800",
              height: 300, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: AppColors.gray100,
                  child: const Center(child: Icon(Icons.image_not_supported, size: 48, color: AppColors.muted)),
                );
              },
            ),
          ),
          Positioned(
            top: 16, right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), border: Border.all(color: Colors.white)),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald500, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text("AI Analyzed", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.sparkles, size: 12, color: AppColors.emerald500),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFruitTypeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("FRUIT TYPE", style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(widget.result.fruitType.isNotEmpty ? widget.result.fruitType : "Unknown", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text("${(widget.result.confidenceFruitType * 100).toStringAsFixed(1)}% confidence", style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFEF2F2), Color(0xFFFEE2E2)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(LucideIcons.apple, color: Colors.redAccent, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildRipenessCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(                "RIPENESS STATUS", style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.result.ripenessStatus.isNotEmpty ? widget.result.ripenessStatus : "Unknown", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.circleCheck, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text("${(widget.result.confidenceRipenessStatus * 100).toStringAsFixed(0)}%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar(widget.result.confidenceRipenessStatus, [AppColors.emerald500, AppColors.cyan500]),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("${(widget.result.confidenceRipenessStatus * 100).toStringAsFixed(1)}% optimal ripeness", style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFreshnessCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.droplets, size: 14, color: Colors.cyan.shade500),
                      const SizedBox(width: 8),
                      const Text("FRESHNESS LEVEL", style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(widget.result.freshnessLevel.isNotEmpty ? widget.result.freshnessLevel : "Unknown", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade50,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(LucideIcons.leaf, color: Colors.cyan.shade600, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar(widget.result.confidenceFreshnessLevel, [Colors.cyan.shade400, Colors.blue.shade400]),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("${(widget.result.confidenceFreshnessLevel * 100).toStringAsFixed(1)}% freshness detected", style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double factor, List<Color> colors) {
    return Container(
      height: 12,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: factor.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity, height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : () => _saveAndNavigate('/history'),
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(LucideIcons.save, size: 20, color: Colors.white),
            label: Text(_isSaving ? "Saving..." : "Save to History", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 56,
          child: OutlinedButton.icon(
            onPressed: _isSaving ? null : () => _saveAndNavigate('/camera'),
            icon: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(LucideIcons.scan, size: 20, color: AppColors.primary),
            label: const Text("Scan Another", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.gray200, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
}
