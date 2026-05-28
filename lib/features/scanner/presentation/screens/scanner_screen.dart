import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_parser.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isProcessing = false;
  DualScanResult? _result;
  bool _mockMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;
      _controller = CameraController(_cameras.first, ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      setState(() => _mockMode = true);
    }
  }

  Future<void> _captureAndProcess() async {
    if (_mockMode) {
      _processMockResult();
      return;
    }
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() { _isProcessing = true; _result = null; });

    try {
      final image = await _controller!.takePicture();
      await _processImage(File(image.path));
    } catch (e) {
      _showError('Capture failed: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() { _isProcessing = true; _result = null; });
    await _processImage(File(picked.path));
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _processImage(File file) async {
    try {
      final inputImage = InputImage.fromFile(file);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final recognized = await recognizer.processImage(inputImage);
      await recognizer.close();

      final text = recognized.text;
      final dual = DateParser.parseDual(text);
      setState(() => _result = dual);

      if (!dual.hasExpiry && !dual.hasMfd) _showNoResult();
    } catch (e) {
      _showError('OCR failed: $e');
    }
  }

  void _processMockResult() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final mockMfd = DateTime.now().subtract(const Duration(days: 120));
      final mockExp = DateTime.now().add(const Duration(days: 240));
      setState(() {
        _result = DualScanResult(
          mfdDate: ParsedDate(date: mockMfd, confidence: 0.85, patternUsed: 'MM/YYYY'),
          expiryDate: ParsedDate(date: mockExp, confidence: 0.87, patternUsed: 'EXP MON YYYY'),
        );
        _isProcessing = false;
      });
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.critical));
  }

  void _showNoResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.ocrNoResult), backgroundColor: AppColors.warning, duration: Duration(seconds: 3)),
    );
  }

  void _useResult() {
    if (_result == null) return;
    context.pop(_result);
  }

  void _manualEntry() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (picked != null && mounted) {
      context.pop(ParsedDate(date: picked, confidence: 1.0, patternUsed: 'Manual'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(AppStrings.scanner, style: TextStyle(color: Colors.white)),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() { _mockMode = !_mockMode; _result = null; }),
            icon: Icon(_mockMode ? Icons.camera_alt_rounded : Icons.science_rounded, color: AppColors.warning, size: 16),
            label: Text(_mockMode ? 'Live' : 'Demo', style: const TextStyle(color: AppColors.warning, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera preview
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera / mock background
                if (!_mockMode && _controller != null && _controller!.value.isInitialized)
                  CameraPreview(_controller!)
                else
                  Container(
                    color: const Color(0xFF1A1A2E),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.science_rounded, color: AppColors.warning.withValues(alpha: 0.6), size: 64),
                          const SizedBox(height: 12),
                          Text('Demo Mode Active', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Will auto-fill a sample expiry date', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                // Scan guide overlay
                if (!_isProcessing && _result == null)
                  _ScanGuide(),
                // Processing overlay
                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 16),
                        Text(AppStrings.ocrProcessing, style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                // Result overlay
                if (_result != null)
                  _ResultOverlay(result: _result!, onUse: _useResult, onRetry: () => setState(() => _result = null)),
              ],
            ),
          ),
          // Bottom controls
          _BottomBar(
            onCapture: _captureAndProcess,
            onGallery: _pickFromGallery,
            onManual: _manualEntry,
            isLoading: _isProcessing,
          ),
        ],
      ),
    );
  }
}

// ── Scan Guide ─────────────────────────────────────────────────────────────────
class _ScanGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 260, height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: const Text(AppStrings.scannerHint, style: TextStyle(color: Colors.white, fontSize: 13)),
        ),
      ],
    );
  }
}

// ── Result Overlay ─────────────────────────────────────────────────────────────
class _ResultOverlay extends StatelessWidget {
  final DualScanResult result;
  final VoidCallback onUse;
  final VoidCallback onRetry;
  const _ResultOverlay({required this.result, required this.onUse, required this.onRetry});

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.safe.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, color: AppColors.safe, size: 48),
                const SizedBox(height: 12),
                const Text('Dates Detected!',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (result.hasMfd) Expanded(child: _DateChip(
                      label: 'MFD',
                      date: _fmt(result.mfdDate!.date),
                      confidence: result.mfdDate!.confidencePercent,
                      color: AppColors.safe,
                    )),
                    if (result.hasMfd && result.hasExpiry) const SizedBox(width: 12),
                    if (result.hasExpiry) Expanded(child: _DateChip(
                      label: 'EXP',
                      date: _fmt(result.expiryDate!.date),
                      confidence: result.expiryDate!.confidencePercent,
                      color: AppColors.warning,
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onRetry,
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white30)),
                        child: const Text('Retry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onUse,
                        child: const Text('Use Dates'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String date;
  final int confidence;
  final Color color;
  const _DateChip({required this.label, required this.date, required this.confidence, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(date, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('$confidence% conf.', style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10)),
        ],
      ),
    );
  }
}


// ── Bottom Controls ────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback onManual;
  final bool isLoading;
  const _BottomBar({required this.onCapture, required this.onGallery, required this.onManual, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery
          IconButton(
            icon: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 28),
            onPressed: isLoading ? null : onGallery,
          ),
          // Capture
          GestureDetector(
            onTap: isLoading ? null : onCapture,
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2)],
              ),
              child: isLoading
                  ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 32),
            ),
          ),
          // Manual entry
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 28),
            onPressed: onManual,
          ),
        ],
      ),
    );
  }
}
