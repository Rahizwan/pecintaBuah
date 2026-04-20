import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:ui';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  final TextEditingController nameController = TextEditingController(text: "Sarah Johnson");
  final TextEditingController emailController = TextEditingController(text: "sarah.johnson@example.com");
  final TextEditingController phoneController = TextEditingController(text: "+1 (555) 123-4567");

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
                        _buildProfileHeader(),
                        const SizedBox(height: 32),
                        _buildStatsCards(),
                        const SizedBox(height: 32),
                        _buildPersonalInformation(),
                        const SizedBox(height: 32),
                        _buildAccountActions(context),
                        const SizedBox(height: 40),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text("Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              // Tombol Edit/Save Toggle
              GestureDetector(
                onTap: () => setState(() => isEditing = !isEditing),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isEditing 
                      ? const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500])
                      : null,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isEditing 
                      ? [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 10)]
                      : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEditing ? LucideIcons.check : LucideIcons.pencil,
                        size: 14,
                        color: isEditing ? Colors.white : AppColors.emerald500,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? "Save" : "Edit",
                        style: TextStyle(
                          color: isEditing ? Colors.white : AppColors.emerald500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: const Icon(LucideIcons.user, size: 60, color: Colors.white),
            ),
            // Tombol Kamera
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray100, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: const Icon(LucideIcons.camera, size: 18, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(nameController.text, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const Text("Member since January 2026", style: TextStyle(color: AppColors.muted, fontSize: 14)),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        _buildStatCard("247", "Total Scans", LucideIcons.chartBar, isHighlighted: false),
        const SizedBox(width: 12),
        _buildStatCard("18", "This Week", null, isHighlighted: true),
        const SizedBox(width: 12),
        _buildStatCard("95%", "Accuracy", LucideIcons.award, isHighlighted: false),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData? icon, {required bool isHighlighted}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isHighlighted ? null : Colors.white,
          gradient: isHighlighted 
            ? const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500])
            : null,
          borderRadius: BorderRadius.circular(24),
          border: isHighlighted ? null : Border.all(color: AppColors.gray100),
          boxShadow: isHighlighted 
            ? [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]
            : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          children: [
            if (icon != null) Icon(icon, color: isHighlighted ? Colors.white : AppColors.emerald500, size: 24),
            if (icon != null) const SizedBox(height: 8),
            Text(value, style: TextStyle(color: isHighlighted ? Colors.white : AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: isHighlighted ? Colors.white70 : AppColors.muted, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Full Name",
          hint: "Your Name",
          prefixIcon: LucideIcons.user,
          controller: nameController,
          enabled: isEditing,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Email",
          hint: "email@example.com",
          prefixIcon: LucideIcons.mail,
          controller: emailController,
          enabled: isEditing,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Phone Number",
          hint: "+1...",
          prefixIcon: LucideIcons.phone,
          controller: phoneController,
          enabled: isEditing,
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildActionCard(LucideIcons.award, "Achievements", "View your badges", AppColors.emerald500, () {}),
        const SizedBox(height: 12),
        _buildActionCard(LucideIcons.logOut, "Logout", "Sign out from your account", Colors.red, () {
          Navigator.pushReplacementNamed(context, '/login');
        }),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: title == "Logout" ? Colors.red.shade900 : AppColors.primary)),
                  Text(subtitle, style: TextStyle(color: title == "Logout" ? Colors.red.shade400 : AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            if (title != "Logout") const Icon(LucideIcons.chevronRight, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}