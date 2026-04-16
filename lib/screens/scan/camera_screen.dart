import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isCameraPermissionDenied = false;
  bool _isScanning = false;
  bool _showResult = false;
  bool _isFrontCamera = false;
  bool _isFlashOn = false;
  File? _capturedImage;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  late AnimationController _scanLineController;
  late Animation<double> _scanLineAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _scanLineController, curve: Curves.linear));

    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() => _isCameraPermissionDenied = true);
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _isCameraPermissionDenied = true);
        return;
      }
      await _startCamera(_cameras[0]);
    } catch (e) {
      setState(() => _isCameraPermissionDenied = true);
    }
  }

  Future<void> _startCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          _cameraController = controller;
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() => _isCameraPermissionDenied = true);
    }
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) return;
    final newIndex = _isFrontCamera ? 0 : 1;
    _isFrontCamera = !_isFrontCamera;
    await _cameraController?.dispose();
    setState(() => _isCameraInitialized = false);
    await _startCamera(_cameras[newIndex]);
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;
    _isFlashOn = !_isFlashOn;
    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  Future<void> _onCapture() async {
    if (_cameraController == null || !_isCameraInitialized) return;
    setState(() => _isScanning = true);

    try {
      final XFile file = await _cameraController!.takePicture();
      // Simulate AI analysis delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _capturedImage = File(file.path);
          _isScanning = false;
          _showResult = true;
        });
      }
    } catch (e) {
      setState(() => _isScanning = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (file == null || !mounted) return;

    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _capturedImage = File(file.path);
        _isScanning = false;
        _showResult = true;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scanLineController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Camera Preview / Fallback ──
          if (_isCameraInitialized && _cameraController != null)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else if (_isCameraPermissionDenied)
            _buildPermissionDeniedBg()
          else
            _buildLoadingBg(),

          // ── Dark vignette overlay ──
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                ),
              ),
            ),
          ),

          // ── UI overlay ──
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const Spacer(),
                _buildScanFrame(),
                const SizedBox(height: 20),
                _buildInstruction(),
                const Spacer(),
                _buildBottomControls(),
                const SizedBox(height: 36),
              ],
            ),
          ),

          // ── Scanning shimmer overlay ──
          if (_isScanning) _buildScanningOverlay(),

          // ── Result sheet ──
          if (_showResult) _buildResultOverlay(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Close
          _glassButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
          // AI Scanner label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.crop_free, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text('AI Scanner',
                    style: AppTextStyles.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          // Flash toggle
          _glassButton(
            onTap: _toggleFlash,
            child: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: _isFlashOn ? Colors.yellow : Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanFrame() {
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        children: [
          // Corner brackets
          _corner(top: 0, left: 0, tl: true),
          _corner(top: 0, right: 0, tr: true),
          _corner(bottom: 0, left: 0, bl: true),
          _corner(bottom: 0, right: 0, br: true),

          // Animated scan line
          AnimatedBuilder(
            animation: _scanLineAnim,
            builder: (_, __) => Positioned(
              top: 260 * _scanLineAnim.value - 1,
              left: 8,
              right: 8,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.primary.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.5), blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),

          // Center sparkle
          Center(
            child: ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.4), width: 1),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: AppColors.primary, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool tl = false,
    bool tr = false,
    bool bl = false,
    bool br = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: (tl || tr)
                ? const BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
            bottom: (bl || br)
                ? const BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
            left: (tl || bl)
                ? const BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
            right: (tr || br)
                ? const BorderSide(color: AppColors.primary, width: 3)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: tl ? const Radius.circular(8) : Radius.zero,
            topRight: tr ? const Radius.circular(8) : Radius.zero,
            bottomLeft: bl ? const Radius.circular(8) : Radius.zero,
            bottomRight: br ? const Radius.circular(8) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildInstruction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        _isCameraPermissionDenied
            ? 'Kamera tidak tersedia'
            : 'Arahkan kamera ke buah',
        style: AppTextStyles.bodyText.copyWith(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gallery
        _glassButton(
          onTap: _pickFromGallery,
          child: const Icon(Icons.image_outlined, color: Colors.white, size: 26),
        ),

        // Capture
        GestureDetector(
          onTap: (_isScanning || _isCameraPermissionDenied) ? null : _onCapture,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _isCameraPermissionDenied
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : AppColors.primaryGradient,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.45),
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: _isScanning
                ? const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
          ),
        ),

        // Flip camera
        _glassButton(
          onTap: _toggleCamera,
          child: const Icon(Icons.flip_camera_ios_outlined,
              color: Colors.white, size: 26),
        ),
      ],
    );
  }

  Widget _buildScanningOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 52,
                height: 52,
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 3),
              ),
              const SizedBox(height: 20),
              Text(
                'Menganalisis buah...',
                style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                    fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'AI sedang memproses gambar',
                style: AppTextStyles.subtitle.copyWith(
                    color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.55),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, -6)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Captured image preview + emoji
                Row(
                  children: [
                    if (_capturedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _capturedImage!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text('🍌', style: TextStyle(fontSize: 44)),
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cavendish Banana',
                            style: AppTextStyles.title.copyWith(
                                fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '✅  Perfectly Ripe',
                              style: AppTextStyles.bodyText.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Confidence: 94%',
                            style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Nutrition row
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _nutritionChip('🔥', '89', 'kcal'),
                      _divider(),
                      _nutritionChip('🌾', '23g', 'Carbs'),
                      _divider(),
                      _nutritionChip('💪', '1.1g', 'Protein'),
                      _divider(),
                      _nutritionChip('💧', '74g', 'Water'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() {
                          _showResult = false;
                          _capturedImage = null;
                        }),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Scan Lagi',
                            style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Simpan',
                              style: AppTextStyles.bodyText.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nutritionChip(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        Text(label,
            style: AppTextStyles.subtitle.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _divider() => Container(
      width: 1, height: 40, color: AppColors.inputBorder);

  Widget _buildPermissionDeniedBg() {
    return Container(
      color: const Color(0xFF0D1B2A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.no_photography_outlined,
                color: Colors.white.withOpacity(0.4), size: 60),
            const SizedBox(height: 16),
            Text('Izin kamera diperlukan',
                style: AppTextStyles.subtitle.copyWith(
                    color: Colors.white60, fontSize: 15)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: openAppSettings,
              child: Text('Buka Pengaturan',
                  style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBg() {
    return Container(
      color: Color(0xFF0D1B2A),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _glassButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(child: child),
      ),
    );
  }
}