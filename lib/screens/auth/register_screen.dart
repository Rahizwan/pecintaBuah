import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.silverBackground,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  AppAssets.logo,
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.apple, color: AppColors.primary, size: 30),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Create your account',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start your fruit scanning journey today',
                  style: AppTextStyles.subtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const CustomTextField(
                  label: 'Full name',
                  hintText: 'Rizki',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Email address',
                  hintText: 'klp.satuHarusAgaksih@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  label: 'Confirm password',
                  hintText: 'Confirm your password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Create account',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    // Logika register nanti di sini
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign in',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.cyan, // Sedikit diubah ke cyan agar sesuai gambar
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}