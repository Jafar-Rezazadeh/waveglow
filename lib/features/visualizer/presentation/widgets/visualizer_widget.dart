import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/color_palette.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerWidget extends StatefulWidget {
  const VisualizerWidget({super.key});

  @override
  State<VisualizerWidget> createState() => _VisualizerWidgetState();
}

class _VisualizerWidgetState extends State<VisualizerWidget> with SingleTickerProviderStateMixin {
  final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  late final AnimationController animationController;
  late final Animation animation;

  late final _controller = Get.find<VisualizerStateController>();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(300, 300),
              painter: VisualizerPainter(
                magnitudesOf128Bars: [],
                colorPalette: _colorPalette,
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            _controller.startListeningToAudio();
          },
          child: const Text("start"),
        ),
        TextButton(
          onPressed: () {
            _controller.stopListeningToAudio();
          },
          child: const Text("stop"),
        ),
      ],
    );
  }
}

class VisualizerPainter extends CustomPainter {
  final AppColorPalette colorPalette;
  final List<double> magnitudesOf128Bars;
  final double radiusModifier = 1;

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.magnitudesOf128Bars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _outerCircle(size, canvas);
  }

  void _outerCircle(Size size, Canvas canvas) {
    final radius = (size.width / 2) * radiusModifier;
    final outerCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: radius);
    final gradient = LinearGradient(
      colors: [
        colorPalette.accent2,
        colorPalette.softPinkAccent,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    outerCirclePaint.shader = gradient.createShader(rect);

    canvas.drawCircle(size.center(Offset.zero), radius, outerCirclePaint);
    canvas.drawCircle(size.center(Offset.zero), radius, outerCirclePaint);
  }

  @override
  bool shouldRepaint(VisualizerPainter oldDelegate) => oldDelegate.radiusModifier != radiusModifier;
}
