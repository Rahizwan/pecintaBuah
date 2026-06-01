import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/app_colors.dart';

class NotificationPopup {
  NotificationPopup._();

  static final AudioPlayer _player = AudioPlayer();

  static void _playSound() {
    try {
      _player.play(AssetSource('audio/notification_sound.mp3'));
    } catch (_) {}
  }

  static void show({
    required OverlayState overlay,
    required String title,
    required String body,
    required String type,
    VoidCallback? onTap,
  }) {
    _playSound();
    IconData icon;
    Color iconBg;
    Color iconColor;

    switch (type) {
      case 'achievement':
        icon = LucideIcons.award;
        iconBg = AppColors.emerald50;
        iconColor = AppColors.emerald500;
        break;
      case 'article_tip':
        icon = LucideIcons.bookOpen;
        iconBg = AppColors.cyan50;
        iconColor = AppColors.cyan500;
        break;
      case 'welcome':
        icon = LucideIcons.heart;
        iconBg = AppColors.emerald50;
        iconColor = AppColors.emerald500;
        break;
      case 'error':
        icon = LucideIcons.octagonAlert;
        iconBg = AppColors.destructive50;
        iconColor = AppColors.destructive;
        break;
      case 'success':
        icon = LucideIcons.circleCheck;
        iconBg = AppColors.emerald50;
        iconColor = AppColors.emerald500;
        break;
      case 'limited':
        icon = LucideIcons.octagonAlert;
        iconBg = Color(0xFFFFF7ED);
        iconColor = Color(0xFFEA580C);
        break;
      default:
        icon = LucideIcons.bell;
        iconBg = AppColors.gray50;
        iconColor = AppColors.muted;
    }

    final showConfetti = type == 'achievement';

    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final effectiveIconBg = isDark ? iconBg.withValues(alpha: 0.15) : iconBg;

        return Stack(
          children: [
            if (showConfetti)
              Positioned.fill(
                child: _ConfettiOverlay(
                  key: ValueKey('confetti_${title.hashCode}'),
                ),
              ),
            _PopupOverlay(
              icon: icon,
              iconBg: effectiveIconBg,
              iconColor: iconColor,
              title: title,
              body: body,
              onTap: onTap,
              onDismiss: () {
                entry?.remove();
              },
            ),
          ],
        );
      },
    );

    overlay.insert(entry);
  }

  static void showMultiple({
    required OverlayState overlay,
    required List<Map<String, dynamic>> notifications,
    Duration interval = const Duration(milliseconds: 2000),
  }) {
    if (notifications.isEmpty) return;

    final achievementCount =
        notifications.where((n) => n['type'] == 'achievement').length;

    int index = 0;

    if (achievementCount > 1) {
      NotificationPopup.show(
        overlay: overlay,
        title: 'Pencapaian Baru!',
        body: 'Kamu mendapatkan $achievementCount pencapaian baru!',
        type: 'achievement',
        onTap: () {},
      );
      index = notifications.length;
    }

    void showNext() {
      if (index >= notifications.length) return;
      final n = notifications[index];
      index++;

      NotificationPopup.show(
        overlay: overlay,
        title: n['title'] ?? '',
        body: n['body'] ?? '',
        type: n['type'] ?? 'welcome',
        onTap: n['onTap'] as VoidCallback?,
      );

      Future.delayed(interval, showNext);
    }

    if (achievementCount <= 1) {
      showNext();
    }
  }
}

class _PopupOverlay extends StatefulWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  const _PopupOverlay({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_PopupOverlay> createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<_PopupOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_dismissed) _dismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark ? AppColors.darkBorder : Colors.grey.shade100;
    final titleColor = isDark ? AppColors.darkText : AppColors.primary;
    final bodyColor = isDark ? AppColors.darkMuted : AppColors.muted;
    final dismissBg = isDark ? AppColors.darkBorder : AppColors.gray50;

    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        _dismiss();
      },
      child: Dismissible(
        key: ValueKey('${widget.title}_${widget.body}_${_dismissed}'),
        direction: DismissDirection.horizontal,
        onDismissed: (_) {
          if (!_dismissed) _dismiss();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: _slideAnimation.value * 80,
                child: child,
              ),
            );
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
              top: topPadding + 8,
            ),
            child: Material(
              elevation: isDark ? 4 : 8,
              shadowColor: isDark ? Colors.black54 : Colors.black26,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.iconBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: titleColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.body,
                            style: TextStyle(
                              color: bodyColor,
                              fontSize: 12,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: dismissBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 16,
                          color: bodyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfettiOverlay extends StatefulWidget {
  const _ConfettiOverlay({super.key});

  @override
  State<_ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<_ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _particles = List.generate(40, (i) => _ConfettiParticle(i));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCompleted) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double yStart;
  final double size;
  final Color color;
  final double speed;
  final double wobble;

  _ConfettiParticle(int i)
      : x = (Random(i * 7 + 13)).nextDouble(),
        yStart = (Random(i * 7 + 17)).nextDouble() * -0.3,
        size = 4 + (Random(i * 7 + 19)).nextDouble() * 6,
        speed = 0.3 + (Random(i * 7 + 23)).nextDouble() * 0.7,
        wobble = (Random(i * 7 + 29)).nextDouble() * 2 * pi,
        color = (() {
          const colors = [
            Color(0xFF10B981),
            Color(0xFF34D399),
            Color(0xFF06B6D4),
            Color(0xFF22D3EE),
            Color(0xFFF59E0B),
            Color(0xFFEF4444),
            Color(0xFF8B5CF6),
            Color(0xFFEC4899),
          ];
          return colors[Random(i * 7 + 31).nextInt(colors.length)];
        })();
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress - p.yStart).clamp(0.0, 1.0) / p.speed;
      if (t < 0 || t > 1) continue;

      final y = t * size.height;
      final wobbleX = sin(p.wobble + t * 12) * 20;
      final x = (p.x * size.width + wobbleX).clamp(0.0, size.width);
      final alpha = (1 - t) * 255;
      final color = p.color.withAlpha(alpha.toInt());
      final rotation = t * 4 * pi;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(2),
        ),
        Paint()..color = color,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
