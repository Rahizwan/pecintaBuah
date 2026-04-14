import 'package:flutter/material.dart';
import '../core/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        // Tambahkan gradasi jika bukan tombol outline
        gradient: isOutlined ? null : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        // Tambahkan efek GLOW (bayangan cahaya)
        boxShadow: isOutlined
            ? []
            : [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.4), // Warna glow biru kehijauan
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 6), // Turun ke bawah sedikit
                ),
              ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Transparan agar gradasi terlihat
          shadowColor: Colors.transparent, // Matikan shadow bawaan tombol
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isOutlined ? const BorderSide(color: AppColors.primary) : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.buttonText.copyWith(
                color: isOutlined ? AppColors.primary : Colors.white,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: Colors.white, size: 20),
            ]
          ],
        ),
      ),
    );
  }
}