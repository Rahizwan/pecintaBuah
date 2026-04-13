import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Icon(Icons.camera_alt, color: Colors.white, size: 80),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
              ),
            ),
          )
        ],
      ),
    );
  }
}