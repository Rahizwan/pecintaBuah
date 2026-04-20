import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
            colors: [AppColors.emerald50, Colors.white, AppColors.gray50],
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
                    // Logo/Icon area
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
                    // Form
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
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?", style: TextStyle(color: AppColors.emerald500, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSignInButton(),
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text("or continue with", style: TextStyle(color: AppColors.muted, fontSize: 12)),
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
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
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
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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