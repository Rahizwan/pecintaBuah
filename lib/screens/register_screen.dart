import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Create Account", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),

            const CustomTextField(hint: "Full Name"),
            const SizedBox(height: 10),

            const CustomTextField(hint: "Email"),
            const SizedBox(height: 10),

            const CustomTextField(hint: "Password", isPassword: true),
            const SizedBox(height: 10),

            const CustomTextField(hint: "Confirm Password", isPassword: true),
            const SizedBox(height: 20),

            CustomButton(
              text: "Create Account",
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}