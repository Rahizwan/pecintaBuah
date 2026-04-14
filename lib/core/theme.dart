import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Warna Solid
  static const Color primary = Color(0xFF00B47D); 
  static const Color cyan = Color(0xFF00BCD4); // Warna biru kehijauan untuk ujung gradasi
  static const Color background = Color(0xFFFFFFFF);
  static const Color textTitle = Color(0xFF2D2D2D);
  static const Color textSubtitle = Color(0xFF9E9E9E);
  static const Color inputBackground = Color(0xFFF5F7F9); 
  static const Color inputBorder = Color(0xFFE2E8F0);

  // --- GRADIENTS (Baru ditambahkan untuk 100% Match) ---
  
  // Gradasi Hijau-Cyan untuk Tombol, Loading Screen, dan Card
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cyan, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradasi Silver Metalik untuk Background Login & Register
  static const LinearGradient silverBackground = LinearGradient(
    colors: [
      Color(0xFFE8ECEF), // Abu-abu terang
      Color(0xFFF8F9FA), // Putih keabu-abuan
      Color(0xFFDDE2E5), // Abu-abu agak gelap
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );
}

// ... (Biarkan bagian AppTextStyles tetap sama seperti sebelumnya) ...

class AppTextStyles {
  // Style default berdasarkan screenshot Figma-mu
  static TextStyle bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Weight 500 = Medium
    height: 20 / 14, // Line height 20px
    letterSpacing: -0.15,
    color: AppColors.textTitle,
  );

  static TextStyle title = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textTitle,
  );

  static TextStyle buttonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static TextStyle inputHint = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSubtitle,
  );

  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSubtitle,
  );
}