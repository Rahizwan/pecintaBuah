import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/splash/loading_screen.dart';
import 'screens/main/home_screen.dart';
import 'screens/main/camera_screen.dart';
import 'screens/main/history_screen.dart';
import 'screens/main/result_screen.dart';
import 'screens/main/profile_screen.dart';
import 'screens/main/notifications_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WhatTheFruitsApp());
}

class WhatTheFruitsApp extends StatelessWidget {
  const WhatTheFruitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'What The Fruits',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, 
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/camera': (context) => const CameraScreen(), 
        '/history': (context) => const HistoryScreen(),
        '/result': (context) => const ResultScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/notifications': (context) => const NotificationScreen(),
      },
    );
  }
}