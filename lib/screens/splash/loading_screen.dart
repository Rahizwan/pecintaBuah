import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/assets.dart';
import '../main/main_navigation.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int currentDot = 0;

  @override
  void initState() {
    super.initState();

    print("LOADING SCREEN MASUK 🔥");

    // animasi titik
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        currentDot = (currentDot + 1) % 3;
      });
    });

    // pindah ke home
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        ),
      );
    });
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentDot == index ? 10 : 6,
      height: currentDot == index ? 10 : 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          currentDot == index ? 1 : 0.4,
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00C9A7),
              Color(0xFF2D9CDB),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset(
              AppAssets.logo,
              width: 150,
            ),

            const SizedBox(height: 20),

            const Text(
              "WHAT THE",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const Text(
              "FRUITS?",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 80),

            const Text(
              "What's The Fruits?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "✨ AI-Powered Fruit Scanner ✨",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildDot(0),
                buildDot(1),
                buildDot(2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}