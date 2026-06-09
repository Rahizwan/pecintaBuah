import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../../core/app_colors.dart';
import '../../widgets/notification_popup.dart';
import '../../widgets/custom_textfield.dart';
import '../../services/api_service.dart';
import '../../services/api_client.dart';
import '../../models/app_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   bool isEditing = false;
   AppUser? currentUser;
   final TextEditingController nameController = TextEditingController();
   final TextEditingController emailController = TextEditingController();
   final TextEditingController phoneController = TextEditingController();
   
   // Profile image upload
   File? _profileImage;
   final ImagePicker _picker = ImagePicker();
   bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await ApiService.getUser();
      setState(() {
        currentUser = user;
        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phoneNumber ?? '';
      });
    } catch (e) {
      debugPrint('Failed to load user: $e');
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
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  const Text("Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (isEditing) {
                    try {
                      final updatedUser = await ApiService.updateProfile(
                        name: nameController.text.isNotEmpty ? nameController.text : null,
                        phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : null,
                      );
                      setState(() {
                        currentUser = updatedUser;
                        isEditing = false;
                      });
                      if (context.mounted) {
                        NotificationPopup.show(
                          overlay: Overlay.of(context, rootOverlay: true),
                          title: 'Berhasil',
                          body: 'Profil berhasil diperbarui.',
                          type: 'success',
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        NotificationPopup.show(
                          overlay: Overlay.of(context, rootOverlay: true),
                          title: 'Gagal',
                          body: 'Gagal memperbarui profil: ${e.toString().replaceFirst('Exception: ', '')}',
                          type: 'error',
                        );
                      }
                    }
                  } else {
                    setState(() => isEditing = true);
                  }
                },
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
     final userName = currentUser?.displayName ?? "Loading...";
     final memberSince = currentUser?.createdAt != null
         ? "Member since ${_formatDate(currentUser!.createdAt!)}"
         : "Member since January 2026";

     return Column(
       children: [
         Stack(
           alignment: Alignment.bottomRight,
           children: [
              _buildProfileAvatar(),
              if (isEditing)
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.gray100, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                    ),
                    child: const Icon(LucideIcons.camera, size: 18, color: AppColors.primary),
                  ),
                ),
           ],
         ),
         const SizedBox(height: 16),
         Text(userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
         Text(memberSince, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
       ],
     );
   }

  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return "${months[date.month - 1]} ${date.year}";
  }

  Widget _buildStatsCards() {
    final totalScans = currentUser?.totalScans ?? 0;
    final thisWeek = currentUser?.scansThisWeekCount ?? 0;
    final accuracy = currentUser?.averageAccuracy ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard("$totalScans", "Total Scans", LucideIcons.chartBar, isHighlighted: false),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard("$thisWeek", "This Week", null, isHighlighted: true),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard("${accuracy.toStringAsFixed(0)}%", "Accuracy", LucideIcons.award, isHighlighted: false),
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData? icon, {required bool isHighlighted}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isHighlighted ? Colors.white70 : AppColors.muted, fontSize: 10, fontWeight: FontWeight.w500)),
        ],
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
          enabled: false,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: "Phone Number",
          hint: "08xxxxxxxxxx",
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
          _buildActionCard(LucideIcons.award, "Achievements", "View your badges", AppColors.emerald500, () => Navigator.pushNamed(context, '/achievements')),
         const SizedBox(height: 12),
         _buildActionCard(LucideIcons.logOut, "Logout", "Sign out from your account", Colors.red, () {
           ApiService.logout();
           Navigator.pushReplacementNamed(context, '/login');
         }),
       ],
     );
   }

   Widget _buildProfileAvatar() {
    final photoPath = currentUser?.profilePhotoPath;
    if (photoPath != null && photoPath.isNotEmpty) {
      final url = '${ApiClient.baseUrl}/storage/$photoPath';
      return ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.network(url, width: 120, height: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildDefaultAvatar()),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: const Icon(LucideIcons.user, size: 60, color: Colors.white),
    );
  }

  Future<void> _pickProfileImage() async {
     if (_isUploading) return;
     
     final XFile? image = await _picker.pickImage(
       source: ImageSource.gallery,
       imageQuality: 85,
     );
     
     if (image == null) return;
     
     setState(() {
       _profileImage = File(image.path);
     });
     
     // Upload the image
     await _uploadProfileImage();
   }

   Future<void> _uploadProfileImage() async {
     if (_profileImage == null) return;
     
     setState(() => _isUploading = true);
     
     try {
       final updatedUser = await ApiService.updateProfile(
         profilePhoto: _profileImage,
       );
       
       setState(() {
         currentUser = updatedUser;
         _profileImage = null;
         _isUploading = false;
       });
       
        if (context.mounted) {
          NotificationPopup.show(
            overlay: Overlay.of(context, rootOverlay: true),
            title: 'Berhasil',
            body: 'Foto profil berhasil diperbarui.',
            type: 'success',
          );
        }
      } catch (e) {
        setState(() => _isUploading = false);
        if (context.mounted) {
          NotificationPopup.show(
            overlay: Overlay.of(context, rootOverlay: true),
            title: 'Gagal',
            body: 'Gagal mengunggah foto: ${e.toString().replaceFirst('Exception: ', '')}',
            type: 'error',
          );
        }
     }
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
