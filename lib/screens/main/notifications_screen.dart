import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import '../../core/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        "title": "Freshness Alert!",
        "desc": "Your Cavendish Banana is at 85% ripeness. Perfect time to eat!",
        "time": "2 mins ago",
        "icon": LucideIcons.apple,
        "isNew": true,
      },
      {
        "title": "Achievement Unlocked",
        "desc": "You've scanned 50 fruits this month! View your new badge.",
        "time": "1 hour ago",
        "icon": LucideIcons.award,
        "isNew": true,
      },
      {
        "title": "System Update",
        "desc": "AI Model updated to v2.4 for better accuracy in citrus detection.",
        "time": "Yesterday",
        "icon": LucideIcons.sparkles,
        "isNew": false,
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return _buildNotificationCard(item);
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

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gray50, Colors.white, Color(0xFFECFDF5)],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(LucideIcons.arrowLeft, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Text(
                "Notifications",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: item['isNew'] ? AppColors.emerald500.withOpacity(0.2) : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item['isNew'] ? AppColors.emerald50 : AppColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              item['icon'],
              color: item['isNew'] ? AppColors.emerald500 : AppColors.muted,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (item['isNew'])
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.emerald500,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'],
                  style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 8),
                Text(
                  item['time'],
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}