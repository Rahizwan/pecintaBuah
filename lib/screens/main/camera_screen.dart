import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  // Logic Camera
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;

  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_scanController);
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _onNewCameraSelected(_cameras![_selectedCameraIndex]);
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
    } catch (e) {
      debugPrint("Error inisialisasi kamera: $e");
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  // Logika Flip Camera
  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;

    setState(() {
      _isCameraInitialized = false;
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    });

    _onNewCameraSelected(_cameras![_selectedCameraIndex]);
  }

  @override
  void dispose() {
    _controller?.dispose(); 
    _scanController.dispose();
    super.dispose();
  }

  void _handleCapture() {
    Navigator.pushNamed(context, '/result');
  }

  void _handleUpload() {
    Navigator.pushNamed(context, '/result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Inisialisasi Preview Kamera
          _buildCameraPreview(),

          // 2. Animated Scanning Line
          _buildScanningLine(),

          // 3. Top Bar 
          _buildTopBar(context),

          // 4. Viewfinder
          _buildViewfinder(),

          // 5. Bottom Controls
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_isCameraInitialized && _controller != null) {
      return SizedBox.expand(
        child: CameraPreview(_controller!),
      );
    }
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF111827), Color(0xFF064E3B), Color(0xFF111827)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.emerald400),
            const SizedBox(height: 16),
            Text(
              "Memuat Kamera...",
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Back
            _buildGlassButton(LucideIcons.x, () => Navigator.pop(context)),
            
            // Badge AI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald400, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Text("AI Scanner", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // TOMBOL FLIP CAMERA
            _buildGlassButton(LucideIcons.refreshCcw, _switchCamera),
          ],
        ),
      ),
    );
  }

  // Helper untuk tombol transparan di atas kamera
  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
  
  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanAnimation,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * _scanAnimation.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.emerald400, Colors.transparent],
              ),
              boxShadow: [
                BoxShadow(color: AppColors.emerald400.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewfinder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 280,
            height: 280,
            child: Stack(
              children: [
                _buildCorner(top: 0, left: 0, rotate: 0),
                _buildCorner(top: 0, right: 0, rotate: 1),
                _buildCorner(bottom: 0, left: 0, rotate: 3),
                _buildCorner(bottom: 0, right: 0, rotate: 2),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.emerald500.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.emerald400, size: 40),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.center_focus_weak, color: AppColors.emerald400, size: 18),
                SizedBox(width: 8),
                Text("Position fruit in center", style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({double? top, double? left, double? right, double? bottom, required int rotate}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: RotatedBox(
        quarterTurns: rotate,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.emerald400, width: 4),
              left: BorderSide(color: AppColors.emerald400, width: 4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSideButton(LucideIcons.image, _handleUpload),
          GestureDetector(
            onTap: _handleCapture,
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera, color: Colors.white, size: 32),
              ),
            ),
          ),
          // Mengganti spacer dengan button kosong untuk menjaga alignment
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}