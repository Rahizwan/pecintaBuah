import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/assets.dart';
import '../auth/login_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _controller.forward();

    // Timer 3 Detik lalu pindah ke halaman Login
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Menggunakan Gradient Cyan-Hijau utama kita
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Stack(
          children: [
            // Emoji Buah Melayang di Background
            ..._buildFloatingIcons(),

            // Konten Tengah (Logo & Text)
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // LOGO (Besar & Clean)
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Image.asset(
                            AppAssets.logo,
                            fit: BoxFit.cover,
                            // Fallback jika logo belum terpasang
                            errorBuilder: (context, error, stackTrace) => 
                                const Icon(Icons.apple, color: Colors.white, size: 60),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Teks Identitas Logo
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'WHAT THE\n',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A3A1A), // Hijau Tua
                                letterSpacing: 2,
                              ),
                            ),
                            TextSpan(
                              text: 'FRUITS',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFE74C3C), // Merah
                                letterSpacing: 3,
                              ),
                            ),
                            TextSpan(
                              text: '?',
                              style: AppTextStyles.title.copyWith(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF27AE60), // Hijau Terang
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Konten Bawah (Tagline & Loading Dots)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'AI-Powered Fruit Scanner',
                          style: AppTextStyles.bodyText.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.auto_awesome,
                            color: Colors.white70, size: 16),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Indikator Titik (Loading Dots)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == 0 ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk memunculkan emoji buah secara acak
  List<Widget> _buildFloatingIcons() {
    final positions = [
      [0.08, 0.06], // Kiri atas
      [0.78, 0.04], // Kanan atas
      [0.05, 0.82], // Kiri bawah
      [0.80, 0.88], // Kanan bawah
    ];
    final icons = ['🍎', '🍊', '🍇', '🍌'];
    
    return List.generate(
      4,
      (i) => Positioned(
        left: MediaQuery.of(context).size.width * positions[i][0],
        top: MediaQuery.of(context).size.height * positions[i][1],
        child: Opacity(
          opacity: 0.25,
          child: Text(
            icons[i],
            style: const TextStyle(fontSize: 52),
          ),
        ),
      ),
    );
  }
}