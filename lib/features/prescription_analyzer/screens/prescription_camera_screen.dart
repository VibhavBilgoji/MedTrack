import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/prescription_analyzer_provider.dart';
import '../widgets/analysis_confirmation_sheet.dart';
import '../../../../core/constants/app_colors.dart';

class PrescriptionCameraScreen extends ConsumerStatefulWidget {
  final List<String> existingMedNames;

  const PrescriptionCameraScreen({
    super.key,
    required this.existingMedNames,
  });

  @override
  ConsumerState<PrescriptionCameraScreen> createState() =>
      _PrescriptionCameraScreenState();
}

class _PrescriptionCameraScreenState
    extends ConsumerState<PrescriptionCameraScreen> {
  CameraController? _controller;
  bool _flashOn = false;
  bool _captured = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      _controller = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_captured || _controller == null || !_controller!.value.isInitialized) return;
    setState(() => _captured = true);

    try {
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.torch);
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      final file = await _controller!.takePicture();
      
      if (_flashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      }
      
      if (!mounted) return;

      // Trigger analysis
      await ref.read(prescriptionAnalyzerProvider.notifier).analyzeImage(
            File(file.path),
            widget.existingMedNames,
          );
    } catch (e) {
      if (mounted) {
        ref.read(prescriptionAnalyzerProvider.notifier).reset();
        setState(() => _captured = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionAnalyzerProvider);

    // When analysis succeeds, show the confirmation bottom sheet
    ref.listen(prescriptionAnalyzerProvider, (_, next) {
      if (next is! PrescriptionAnalyzerState) return;
      next.maybeWhen(
        success: (result) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AnalysisConfirmationSheet(result: result),
          ).then((_) {
            ref.read(prescriptionAnalyzerProvider.notifier).reset();
            setState(() => _captured = false);
          });
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          if (_controller?.value.isInitialized == true)
            CameraPreview(_controller!),

          // Prescription crop guide overlay
          _PrescriptionOverlay(),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'AI Prescription Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: _flashOn ? Colors.amber : Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() => _flashOn = !_flashOn);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Hint text
          Positioned(
            bottom: 160,
            left: 0,
            right: 0,
            child: Text(
              'Align prescription within the frame\nEnsure clear lighting for best AI results',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 400.ms),
          ),

          // Capture / analyzing button
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: state.maybeWhen(
                analyzing: () => const _AnalyzingIndicator(),
                orElse: () => _CaptureButton(onTap: _capture),
              ),
            ),
          ),

          // Error snackbar overlay
          if (state.mapOrNull(error: (e) => e.message) != null)
            Positioned(
              bottom: 150,
              left: 20,
              right: 20,
              child: _ErrorBanner(
                message: state.mapOrNull(error: (e) => e.message)!,
                onRetry: () {
                  ref.read(prescriptionAnalyzerProvider.notifier).reset();
                  setState(() => _captured = false);
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _PrescriptionOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dimPaint = Paint()..color = Colors.black.withOpacity(0.65);
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rect = Rect.fromLTWH(
      32,
      size.height * 0.2,
      size.width - 64,
      size.height * 0.48,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, dimPaint);
    canvas.drawRRect(rrect, clearPaint);
    canvas.restore();
    
    // Draw corners
    _drawCorners(canvas, rect, borderPaint);
  }
  
  void _drawCorners(Canvas canvas, Rect rect, Paint paint) {
    const length = 30.0;
    
    // Top Left
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(length, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, length), paint);
    
    // Top Right
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(-length, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(0, length), paint);
    
    // Bottom Left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(length, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(0, -length), paint);
    
    // Bottom Right
    canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(-length, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(0, -length), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack);
  }
}

class _AnalyzingIndicator extends StatelessWidget {
  const _AnalyzingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Gemini is analyzing prescription...',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 15,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 4)]
          ),
        ),
      ],
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1500.ms, color: Colors.white30);
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.critical,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white24,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Retry',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, duration: 300.ms, curve: Curves.easeOutCirc);
  }
}
