import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../services/auth_service.dart';
import '../../widgets/notification_popup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool showPassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      NotificationPopup.show(
        overlay: Overlay.of(context, rootOverlay: true),
        title: 'Lengkapi Data',
        body: 'Harap isi email dan password.',
        type: 'error',
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      if (mounted) {
        final overlay = Overlay.of(context, rootOverlay: true);
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );

        final newNotifications = data['new_notifications'] as List<dynamic>? ?? [];

        if (newNotifications.isNotEmpty) {
          NotificationPopup.showMultiple(
            overlay: overlay,
            notifications: newNotifications.cast<Map<String, dynamic>>(),
          );
        } else {
          final userName = data['user']?['name'] ?? 'pengguna';
          NotificationPopup.show(
            overlay: overlay,
            title: 'Selamat Datang Kembali!',
            body: 'Halo $userName, senang melihatmu kembali!',
            type: 'success',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal Masuk',
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
              colors: [AppColors.emerald50, AppColors.background, AppColors.gray50],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80, right: -20,
                child: Container(
                  width: 160, height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.emerald500.withOpacity(0.1),
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
                          gradient: const LinearGradient(
                            colors: [AppColors.emerald400, AppColors.cyan400],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emerald500.withOpacity(0.3),
                              blurRadius: 20, offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Welcome Back",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1),
                      ),
                      const Text(
                        "Sign in to continue your fruit journey",
                        style: TextStyle(color: AppColors.muted, fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: "Email",
                        hint: "your@email.com",
                        prefixIcon: Icons.mail_outline,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: "Password",
                        hint: "Enter your password",
                        prefixIcon: Icons.lock_outline,
                        controller: passwordController,
                        isPassword: !showPassword,
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSignInButton(),
                      const SizedBox(height: 40),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text("Sign up", style: TextStyle(color: AppColors.emerald500, fontWeight: FontWeight.bold)),
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

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.emerald500.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
