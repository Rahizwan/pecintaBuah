import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/app_colors.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
              "https://images.unsplash.com/photo-1757283961570-f6b9019753e9?w=800",
              height: 300, width: double.infinity, fit: BoxFit.cover,
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("FRUIT TYPE", style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Apple", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text("Malus domestica", style: TextStyle(color: AppColors.muted, fontSize: 12, fontStyle: FontStyle.italic)),
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("RIPENESS STATUS", style: TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Ripe", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
                    const Text("Perfect", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProgressBar(0.85, [AppColors.emerald500, AppColors.cyan500]),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("85% optimal ripeness", style: TextStyle(color: AppColors.muted, fontSize: 12)),
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
                  const Text("High", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
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
          // Menggunakan progress bar biru-cyan untuk membedakan dari Ripeness
          _buildProgressBar(0.92, [Colors.cyan.shade400, Colors.blue.shade400]),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("92% freshness detected", style: TextStyle(color: AppColors.muted, fontSize: 12)),
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
        widthFactor: factor,
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/history'),
            icon: const Icon(LucideIcons.save, size: 20, color: Colors.white),
            label: const Text("Save to History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, height: 56,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/camera'),
            icon: const Icon(LucideIcons.scan, size: 20, color: AppColors.primary),
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