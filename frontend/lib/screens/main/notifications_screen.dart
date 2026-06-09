import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import 'article_detail_screen.dart';
import '../../core/app_colors.dart';
import '../../services/api_service.dart';
import '../../models/app_notification.dart';
import '../../widgets/notification_popup.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _activeTab = 0;
  List<AppNotification> _allNotifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifications = await ApiService.getNotifications();

      if (mounted) {
        setState(() {
          _allNotifications = notifications;
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

  List<AppNotification> get _updates {
    return _allNotifications.where((n) => n.type != 'article_tip').toList();
  }

  List<AppNotification> get _fruitTips {
    return _allNotifications.where((n) => n.type == 'article_tip').toList();
  }

  Future<void> _markAsRead(AppNotification notification) async {
    try {
      await ApiService.markNotificationAsRead(notification.id);
      setState(() {
        _allNotifications = _allNotifications.map((n) {
          if (n.id == notification.id) {
            return AppNotification(
              id: n.id,
              title: n.title,
              body: n.body,
              type: n.type,
              articleId: n.articleId,
              article: n.article,
              readAt: DateTime.now(),
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal',
          body: 'Gagal menandai sebagai dibaca: ${e.toString().replaceFirst('Exception: ', '')}',
          type: 'error',
        );
      }
    }
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    try {
      await ApiService.deleteNotification(notification.id);
      setState(() {
        _allNotifications.removeWhere((n) => n.id == notification.id);
      });
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal',
          body: e.toString().replaceFirst('Exception: ', ''),
          type: 'error',
        );
      }
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ApiService.markAllNotificationsAsRead();
      setState(() {
        _allNotifications = _allNotifications.map((n) {
          return AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            articleId: n.articleId,
            article: n.article,
            readAt: DateTime.now(),
            createdAt: n.createdAt,
          );
        }).toList();
      });
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal',
          body: 'Gagal menandai semua sebagai dibaca: ${e.toString().replaceFirst('Exception: ', '')}',
          type: 'error',
        );
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
                _buildTabSwitcher(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.emerald500))
                      : _error != null
                          ? _buildErrorState()
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _activeTab == 0
                                  ? _buildNotificationList()
                                  : _buildFruitTipsList(),
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
              const Spacer(),
              if (_activeTab == 0 && _updates.any((n) => n.isUnread))
                GestureDetector(
                  onTap: _markAllAsRead,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.emerald50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Mark all read",
                      style: TextStyle(
                        color: AppColors.emerald500,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                  Icon(icon, size: 18, color: isActive ? Colors.white : AppColors.muted),
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.muted),
          const SizedBox(height: 16),
          Text(_error ?? 'Something went wrong'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    final items = _updates;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.inbox, size: 64, color: AppColors.muted.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text("No notifications yet", style: TextStyle(color: AppColors.muted)),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildNotificationCard(items[index]),
    );
  }

  Widget _buildFruitTipsList() {
    final items = _fruitTips;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.bookOpen, size: 64, color: AppColors.muted.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text("No fruit tips yet", style: TextStyle(color: AppColors.muted)),
          ],
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildFruitTipCard(items[index]),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    return GestureDetector(
      onTap: () => _showNotificationPopup(notification),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: notification.isUnread
              ? AppColors.emerald500.withOpacity(0.2)
              : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification.isUnread ? AppColors.emerald50 : AppColors.gray50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  notification.type == 'achievement' ? LucideIcons.award : LucideIcons.bell,
                  color: notification.isUnread ? AppColors.emerald500 : AppColors.muted,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: notification.isUnread ? AppColors.primary : AppColors.muted,
                            ),
                          ),
                        ),
                        if (notification.isUnread)
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
                      notification.body,
                      style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimeAgo(notification.createdAt),
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (notification.isUnread)
                GestureDetector(
                  onTap: () => _markAsRead(notification),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.emerald50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Mark as Read",
                      style: TextStyle(
                        color: AppColors.emerald500,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _deleteNotification(notification),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildFruitTipCard(AppNotification notification) {
    return GestureDetector(
      onTap: () => _showFruitTipPopup(notification),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: notification.isUnread ? AppColors.cyan500.withOpacity(0.15) : Colors.grey.shade100,
        ),
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
              if (notification.article != null)
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
                    notification.article!.tag,
                    style: const TextStyle(
                      color: AppColors.cyan500,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              const Spacer(),
              if (notification.article != null)
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
                        notification.article!.readTime,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            notification.title.replaceFirst('Fruit Tips: ', ''),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: notification.isUnread ? AppColors.primary : AppColors.muted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            notification.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (notification.isUnread)
                GestureDetector(
                  onTap: () => _markAsRead(notification),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cyan50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Mark as Read",
                      style: TextStyle(
                        color: AppColors.cyan500,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              if (notification.isUnread) const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openArticle(notification),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.emerald500, width: 1.5),
                    color: AppColors.emerald500.withOpacity(0.03),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.bookOpen, color: AppColors.emerald500, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "Read full tips",
                        style: TextStyle(color: AppColors.emerald500, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Icon(LucideIcons.arrowRight, color: AppColors.emerald500, size: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  void _showNotificationPopup(AppNotification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: notification.isUnread ? AppColors.emerald50 : AppColors.gray50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        notification.type == 'achievement' ? LucideIcons.award : LucideIcons.bell,
                        color: notification.isUnread ? AppColors.emerald500 : AppColors.muted,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      notification.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _formatTimeAgo(notification.createdAt),
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        if (notification.isUnread)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(ctx);
                                _markAsRead(notification);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.emerald500,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.check, color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Mark as Read",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (notification.isUnread) const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              _deleteNotification(notification);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.trash2, color: Colors.red.shade400, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFruitTipPopup(AppNotification notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(top: 60),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (notification.article != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.cyan50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              notification.article!.tag,
                              style: const TextStyle(
                                color: AppColors.cyan500,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                  notification.article!.readTime,
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cyan50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(LucideIcons.bookOpen, color: AppColors.cyan500, size: 36),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      notification.title.replaceFirst('Fruit Tips: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notification.body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        if (notification.isUnread)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(ctx);
                                _markAsRead(notification);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.cyan500,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.check, color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Mark as Read",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (notification.isUnread) const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              _openArticle(notification);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.emerald500, width: 1.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.bookOpen, color: AppColors.emerald500, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    "Read Article",
                                    style: TextStyle(
                                      color: AppColors.emerald500,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openArticle(AppNotification notification) async {
    if (notification.article == null) return;
    try {
      final article = await ApiService.getArticleDetail(notification.article!.id);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal',
          body: 'Gagal memuat artikel: ${e.toString().replaceFirst('Exception: ', '')}',
          type: 'error',
        );
      }
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${months[dateTime.month - 1]} ${dateTime.day}";
    }
  }
}
