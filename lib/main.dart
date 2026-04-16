import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/splash/loading_screen.dart';

void main() {
  runApp(const FruitApp());
}

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Scanner',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        // Kita terapkan font Inter secara global di sini nanti
      ),
      home: const LoadingScreen(), // Mulai dari halaman Login
    );
  }
}