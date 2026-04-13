import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome back", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),

            const CustomTextField(hint: "Email"),
            const SizedBox(height: 10),

            const CustomTextField(
              hint: "Password",
              isPassword: true,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: "Sign In",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Create account"),
            )
          ],
        ),
      ),
    );
  }
}