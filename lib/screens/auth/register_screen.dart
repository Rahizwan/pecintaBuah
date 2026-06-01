import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../services/auth_service.dart';
import '../../widgets/notification_popup.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool showPassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationPopup.show(
        overlay: Overlay.of(context, rootOverlay: true),
        title: 'Lengkapi Data',
        body: 'Harap isi semua field.',
        type: 'error',
      );
      return;
    }
    if (passwordController.text.length < 6) {
      NotificationPopup.show(
        overlay: Overlay.of(context, rootOverlay: true),
        title: 'Password Terlalu Pendek',
        body: 'Password minimal 6 karakter.',
        type: 'error',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text,
      );
      if (mounted) {
        final overlay = Overlay.of(context, rootOverlay: true);
        Navigator.pushReplacementNamed(context, '/login');
        NotificationPopup.show(
          overlay: overlay,
          title: 'Pendaftaran Berhasil!',
          body: 'Silakan masuk dengan email dan password Anda.',
          type: 'welcome',
        );
      }
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Registrasi Gagal',
          body: e.toString().replaceFirst('Exception: ', ''),
          type: 'error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.cyan50, AppColors.background, AppColors.emerald50],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 40, left: -20,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.cyan400.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.cyan400, AppColors.emerald400]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(color: AppColors.cyan500.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Create Account",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                      ),
                      const Text(
                        "Join us to start identifying fruits with AI",
                        style: TextStyle(color: AppColors.muted, fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        label: "Full Name",
                        hint: "John Doe",
                        prefixIcon: Icons.person_outline,
                        controller: nameController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "Email",
                        hint: "your@email.com",
                        prefixIcon: Icons.mail_outline,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "Password",
                        hint: "Create a password",
                        prefixIcon: Icons.lock_outline,
                        controller: passwordController,
                        isPassword: !showPassword,
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildRegisterButton(),
                      const SizedBox(height: 40),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text("Sign in", style: TextStyle(color: AppColors.cyan500, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.cyan500, AppColors.emerald500]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cyan500.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
