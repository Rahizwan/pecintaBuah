import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import '../../core/app_colors.dart';
import '../../services/scan_service.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/notification_popup.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;

  final ImagePicker _picker = ImagePicker();

  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  bool _hasShownLimitNotice = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_scanController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownLimitNotice) {
        _hasShownLimitNotice = true;
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Informasi Fitu Terbatas',
          body: 'Silahkan scan diantara buah berikut: Apel, Jeruk, dan Pisang',
          type: 'limited',
        );
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint("Gagal mendapatkan daftar kamera: $e");
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal Kamera',
          body: 'Tidak dapat mengakses kamera. Periksa izin atau restart aplikasi.',
          type: 'error',
        );
      }
      return;
    }
    if (!mounted) return;
    if (_cameras != null && _cameras!.isNotEmpty) {
      _onNewCameraSelected(_cameras![_selectedCameraIndex]);
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousController = _controller;
    if (previousController != null) {
      await previousController.dispose();
    }

    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;

    try {
      await controller.initialize();
      if (!mounted || _controller != controller) {
        await controller.dispose();
        return;
      }
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Error inisialisasi kamera: $e");
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal Kamera',
          body: 'Tidak dapat menginisialisasi kamera. Coba restart aplikasi.',
          type: 'error',
        );
      }
    }
  }

  // Logika Flip Camera
  void _switchCamera() {
    if (_isProcessing) return;
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

  Future<void> _handleCapture() async {
    if (_isProcessing) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);

    try {
      final XFile image = await _controller!.takePicture();
      final File imageFile = File(image.path);

      final result = await ScanService.previewImage(imageFile);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/result', arguments: result);
      }
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal Scan',
          body: 'Scan gagal: ${e.toString().replaceFirst('Exception: ', '')}',
          type: 'error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _handleUpload() async {
    setState(() => _isProcessing = true);

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) {
        final File imageFile = File(image.path);
        final result = await ScanService.previewImage(imageFile);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/result', arguments: result);
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          overlay: Overlay.of(context, rootOverlay: true),
          title: 'Gagal Upload',
          body: 'Upload gagal: ${e.toString().replaceFirst('Exception: ', '')}',
          type: 'error',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
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
          SizedBox(
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
          _buildSideButton(LucideIcons.image, _isProcessing ? null : _handleUpload),
          GestureDetector(
            onTap: _isProcessing ? null : _handleCapture,
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _isProcessing ? Colors.grey.shade300 : Colors.white,
                shape: BoxShape.circle,
              ),
              child: _isProcessing
                  ? const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3)))
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [AppColors.emerald500, AppColors.cyan500]),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera, color: Colors.white, size: 32),
                    ),
            ),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildSideButton(IconData icon, VoidCallback? onTap) {
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