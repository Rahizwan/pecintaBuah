import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40),
            const SizedBox(height: 10),
            const Text("Minimal A", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),

            const ListTile(
              title: Text("Email"),
              subtitle: Text("user@email.com"),
            ),

            const ListTile(
              title: Text("Phone"),
              subtitle: Text("+62xxxx"),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}