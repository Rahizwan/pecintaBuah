import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cyan50, Colors.white, AppColors.emerald50],
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
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("or sign up with", style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildSocialButton("Google")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSocialButton("GitHub")),
                      ],
                    ),
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
        onPressed: () async {
          bool success = await authService.register(nameController.text, emailController.text, passwordController.text);
          if (success && mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Create Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSocialButton(String label) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
    );
  }
}