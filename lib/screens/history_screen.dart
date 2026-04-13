import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fruits = ["Apple", "Banana", "Orange"];

    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.food_bank),
            title: Text(fruits[index]),
            subtitle: const Text("March 2026"),
          );
        },
      ),
    );
  }
}