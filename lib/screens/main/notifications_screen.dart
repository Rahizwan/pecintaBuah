import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import 'article_detail_screen.dart';
import '../../core/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _activeTab = 0; // 0: Updates, 1: Fruit Tips
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

  // Data Dummy untuk Artikel (Fruit Tips)
  final List<Map<String, dynamic>> articles = [
    {
      "title": "How to Store Berries Longer",
      "desc": "Keep your strawberries and blueberries fresh for up to 2 weeks with this simple vinegar wash trick.",
      "category": "Storage",
      "readTime": "3 min read",
      "icon": LucideIcons.container,
    },
    {
      "title": "The Truth About Fuji Apples",
      "desc": "Discover why Fuji apples are considered the king of sweetness and their hidden nutritional values.",
      "category": "Nutrition",
      "readTime": "5 min read",
      "icon": LucideIcons.info,
    },
    {
      "title": "Ethylene Gas Guide",
      "desc": "Which fruits should you never store together? Avoid premature rotting with this guide.",
      "category": "Science",
      "readTime": "4 min read",
      "icon": LucideIcons.microscope,
    },
  ];

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
                _buildTabSwitcher(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _activeTab == 0 
                      ? _buildNotificationList() 
                      : _buildArticleList(),
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                "Inbox",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: _activeTab == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.emerald500, AppColors.cyan500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald500.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildTabButton(0, "Updates", LucideIcons.bell),
                _buildTabButton(1, "Fruit Tips", LucideIcons.bookOpen),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    bool isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Row(
                key: ValueKey(isActive),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon, 
                    size: 18, 
                    color: isActive ? Colors.white : AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                      color: isActive ? Colors.white : AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(24),
      itemCount: notifications.length,
      itemBuilder: (context, index) => _buildNotificationCard(notifications[index]),
    );
  }

  Widget _buildArticleList() {
    return ListView.builder(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      itemCount: articles.length,
      itemBuilder: (context, index) => _buildArticleCard(articles[index]),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: item['isNew'] ? AppColors.emerald500.withOpacity(0.2) : Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconBox(item['icon'], item['isNew']),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (item['isNew']) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald500, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item['desc'], style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4)),
                const SizedBox(height: 8),
                Text(item['time'], style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: item),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cyan500.withOpacity(0.1),
                        AppColors.emerald500.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.cyan500.withOpacity(0.2)),
                  ),
                  child: Text(
                    item['category'], 
                    style: const TextStyle(
                      color: AppColors.cyan500, 
                      fontSize: 11, 
                      fontWeight: FontWeight.bold, 
                      letterSpacing: 0.5
                    )
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.clock, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        item['readTime'], 
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11)
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'article_icon_${item['title']}',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.cyan500.withOpacity(0.1),
                          AppColors.emerald500.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'], 
                      color: AppColors.cyan500, 
                      size: 24
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'], 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                          color: AppColors.primary,
                          height: 1.3,
                        )
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['desc'], 
                        maxLines: 2, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(
                          color: Colors.grey.shade600, 
                          fontSize: 13, 
                          height: 1.4
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.emerald500,
                  width: 1.5,
                ),
                color: AppColors.emerald500.withOpacity(0.03),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bookOpen, 
                    color: AppColors.emerald500, 
                    size: 16
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Read full tips", 
                    style: TextStyle(
                      color: AppColors.emerald500, 
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    LucideIcons.arrowRight, 
                    color: AppColors.emerald500, 
                    size: 14
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, bool isNew, {bool isArticle = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isArticle ? AppColors.cyan50 : (isNew ? AppColors.emerald50 : AppColors.gray50),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: isArticle ? AppColors.cyan500 : (isNew ? AppColors.emerald500 : AppColors.muted), size: 24),
    );
  }
}