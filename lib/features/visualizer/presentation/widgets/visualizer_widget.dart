import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  late final _controller = Get.find<VisualizerStateController>();

  late final Ticker _ticker;
  VisualizerBandsEntity smoothedBands = VisualizerBandsEntity(
    subBass: 0,
    bass: 0,
    lowMid: 0,
    mid: 0,
    highMid: 0,
    presence: 0,
    brilliance: 0,
    loudness: 0,
  );

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final currentBands = _controller.perceptualBands; // the latest values from your EventChannel

      smoothedBands = smoothBands(previous: smoothedBands, current: currentBands);

      setState(() {});
    });
    _ticker.start();
  }

  VisualizerBandsEntity smoothBands({
    required VisualizerBandsEntity previous,
    VisualizerBandsEntity? current, // nullable
    double attack = 0.4,
    double decay = 0.05,
  }) {
    double smooth(double prev, double? cur) {
      if (cur == null) return prev;
      if (cur > prev) return prev * (1 - attack) + cur * attack;
      return prev * (1 - decay) + cur * decay;
    }

    return VisualizerBandsEntity(
      subBass: smooth(previous.subBass, current?.subBass),
      bass: smooth(previous.bass, current?.bass),
      lowMid: smooth(previous.lowMid, current?.lowMid),
      mid: smooth(previous.mid, current?.mid),
      highMid: smooth(previous.highMid, current?.highMid),
      presence: smooth(previous.presence, current?.presence),
      brilliance: smooth(previous.brilliance, current?.brilliance),
      loudness: smooth(previous.loudness, current?.loudness),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: const Size(1200, 300),
          painter: VisualizerPainter(
            colorPalette: _colorPalette,
            perceptualBands: smoothedBands,
          ),
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
  final VisualizerBandsEntity? perceptualBands;
  final double circleRadius;

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.perceptualBands,
    this.circleRadius = 90.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (perceptualBands != null) {
      final subBassScaled = (perceptualBands!.subBass * 100);
      final bassScaled = (perceptualBands!.bass * 100);

      _subBass(size, subBassScaled, canvas);
      _bass(size, bassScaled, canvas);
      _baseCircle(size, canvas, circleRadius);
      // TODO: connect them to make it better
    }
  }

  void _subBass(Size size, double subBassScaled, Canvas canvas) {
    final paint = Paint()
      ..color = colorPalette.softPinkAccent
      ..style = PaintingStyle.fill
      ..strokeWidth = 20;
    final path = Path();

    final center = Offset(size.width / 2, size.height / 2);
    final controlOffset = circleRadius * 1.33;
    final endOffset = circleRadius * 0.90;
    final topY = center.dy - circleRadius;
    final controlY = center.dy - circleRadius + (circleRadius * -1.01); // similar to previous 10
    final endY = center.dy - circleRadius + (circleRadius * 0.60); // similar to previous -20

    // Right side
    path.moveTo(center.dx, topY);
    path.conicTo(
      center.dx + controlOffset,
      controlY,
      center.dx + endOffset,
      endY,
      subBassScaled / 50,
    );

    // Left side (mirror)
    path.moveTo(center.dx, topY);
    path.conicTo(
      center.dx - controlOffset,
      controlY,
      center.dx - endOffset,
      endY,
      subBassScaled / 50,
    );

    // Blur/glow paint
    final blurRadius = (subBassScaled / 10).clamp(2, 30).toDouble(); // dynamic blur
    final glowPaint = Paint()
      ..color = colorPalette.accent2.withOpacity((subBassScaled / 100).clamp(0.2, 0.7))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.drawPath(path, glowPaint);

    canvas.drawPath(path, paint);
  }

  void _bass(Size size, double bassScaled, Canvas canvas) {
    final paint = Paint()
      ..color = colorPalette.accent2
      ..style = PaintingStyle.fill
      ..strokeWidth = 20;
    final path = Path();

    final spaceFromCenterStart = circleRadius * 0.9;
    final center = Offset(size.width / 2, size.height / 2);
    final startY = center.dy - circleRadius * 0.4;
    final controlX = circleRadius * 1.9;
    final endX = circleRadius * 1;
    final controlY = center.dy - (circleRadius * 0.7);
    final endY = center.dy + (circleRadius * 0.1);

    // Right side
    path.moveTo(center.dx + spaceFromCenterStart, startY);
    path.conicTo(
      center.dx + controlX,
      controlY,
      center.dx + endX,
      endY,
      bassScaled / 50,
    );

    // Left side (mirror)
    path.moveTo(center.dx - spaceFromCenterStart, startY);
    path.conicTo(
      center.dx - controlX,
      controlY,
      center.dx - endX,
      endY,
      bassScaled / 50,
    );

    // Blur/glow paint
    final blurRadius = (bassScaled / 10).clamp(2, 30).toDouble();
    final glowPaint = Paint()
      ..color = colorPalette.softPinkAccent.withOpacity((bassScaled / 100).clamp(0.2, 0.7))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  void _baseCircle(Size size, Canvas canvas, double scaledRadius) {
    final outerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: scaledRadius);
    final gradient = LinearGradient(
      colors: [
        colorPalette.accent2,
        colorPalette.softPinkAccent,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    outerCirclePaint.shader = gradient.createShader(rect);

    canvas.drawCircle(size.center(Offset.zero), scaledRadius, outerCirclePaint);
    canvas.drawCircle(size.center(Offset.zero), scaledRadius, outerCirclePaint);
  }

  @override
  bool shouldRepaint(VisualizerPainter oldDelegate) =>
      perceptualBands != oldDelegate.perceptualBands;
}
