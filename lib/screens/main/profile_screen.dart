import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.background,
              floating: true,
              pinned: true,
              // Mengaktifkan tombol back untuk kembali ke Home
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textTitle),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Profile',
                style: AppTextStyles.title.copyWith(fontSize: 20),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                  label: Text(
                    'Edit',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(height: 1, color: AppColors.inputBorder),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), // Disesuaikan menjadi 24 agar sejajar
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    _buildAvatar(),

                    const SizedBox(height: 16),

                    Text(
                      'Rizki', // Diubah menjadi Rizki sesuai Home Screen
                      style: AppTextStyles.title.copyWith(fontSize: 22),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Member since January 2026',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 13),
                    ),

                    const SizedBox(height: 24),

                    _buildStatsRow(),

                    const SizedBox(height: 28),

                    _buildSectionTitle('Personal Information'),

                    const SizedBox(height: 14),

                    _buildInfoField(
                      label: 'Full Name',
                      value: 'Rizki',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 12),

                    _buildInfoField(
                      label: 'Email',
                      value: 'klp.satuHarusAgaksih@email.com',
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 12),

                    _buildInfoField(
                      label: 'Phone Number',
                      value: '+1 (555) 123-4567',
                      icon: Icons.phone_outlined,
                    ),

                    const SizedBox(height: 28),

                    _buildSectionTitle('Account'),

                    const SizedBox(height: 14),

                    _buildAccountTile(
                      icon: Icons.workspace_premium_outlined,
                      iconBg: AppColors.primary.withOpacity(0.12),
                      iconColor: AppColors.primary,
                      title: 'Achievements',
                      subtitle: 'View your badges',
                      onTap: () {},
                    ),

                    const SizedBox(height: 12),

                    _buildAccountTile(
                      icon: Icons.logout_rounded,
                      iconBg: const Color(0xFFFFEBEB),
                      iconColor: const Color(0xFFE74C3C),
                      title: 'Logout',
                      subtitle: 'Sign out from your account',
                      titleColor: const Color(0xFFE74C3C),
                      onTap: () {
                        // Kembali ke halaman Login dan hapus seluruh riwayat layar
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Center( // Menggunakan Center dan teks agar sesuai inisial di Home
            child: Text(
              'R',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt_outlined, color: AppColors.textSubtitle, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatChip('247', 'Total Scans'),
        const SizedBox(width: 12),
        _buildStatChip('18', 'This Week'),
        const SizedBox(width: 12),
        _buildStatChip('95%', 'Accuracy'),
      ],
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder), // Tambah border tipis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // Dibuat lebih soft
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.title.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.subtitle.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: AppTextStyles.title.copyWith(fontSize: 16),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSubtitle, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: titleColor != null
                ? titleColor.withOpacity(0.2)
                : AppColors.inputBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.textTitle,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 12,
                      color: titleColor?.withOpacity(0.7) ?? AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: titleColor ?? AppColors.textSubtitle, size: 20),
          ],
        ),
      ),
    );
  }
}