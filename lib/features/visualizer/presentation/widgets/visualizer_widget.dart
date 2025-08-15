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

  double smoothedBass = 0;
  double smoothingFactor = 0.015;
  double smoothBarsFactor = 0.1;
  List<double> smoothedMagnitudes = [];

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final mags = _controller.magnitudes;

      if (mags.isNotEmpty) {
        // Smooth bass
        final sublist = _controller.magnitudes.sublist(1, 5);

        final bass = sublist.reduce((a, b) => a + b) / sublist.length;
        smoothedBass = (smoothedBass + (bass - smoothedBass) * smoothingFactor).clamp(0, 1);

        // Smooth all magnitudes
        _smoothEachBar(mags);
      } else {
        smoothedMagnitudes = [];
      }
      setState(() {});
    });
    _ticker.start();
  }

  void _smoothEachBar(List<double> mags) {
    if (smoothedMagnitudes.length != mags.length) {
      smoothedMagnitudes = List<double>.from(mags);
    } else {
      for (int i = 0; i < mags.length; i++) {
        smoothedMagnitudes[i] =
            (smoothedMagnitudes[i] + (mags[i] - smoothedMagnitudes[i]) * smoothBarsFactor)
                .clamp(0, 1);
      }
    }
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
            radiusValue: smoothedBass,
            magnitudes:
                smoothedMagnitudes.isNotEmpty ? smoothedMagnitudes.getRange(0, 200).toList() : [],
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
  final double radiusValue;
  final List<double> magnitudes;

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.magnitudes,
    this.radiusValue = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaledRadius = (radiusValue * 2000);

    final paint = Paint()..color = Colors.blue;
    canvas.drawColor(Colors.pink.withAlpha(scaledRadius.toInt()), BlendMode.srcIn);
    _outerCircle(size, canvas, scaledRadius);

    // print(scaledRadius);
    // canvas.drawCircle(
    //   Offset(size.width / 2, size.height / 2),
    //   scaledRadius,
    //   paint,
    // );

    final barWidth = size.width / magnitudes.length;

    if (magnitudes.isNotEmpty) {
      for (int i = 0; i < magnitudes.length; i++) {
        final magnitude = magnitudes[i];
        final barHeight = magnitude * 1000; // Scale for visibility
        final x = i * barWidth;
        final barRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth * 0.8, barHeight),
          Radius.circular(barWidth * 0.4), // Half the bar width for full roundness
        );
        canvas.drawRRect(barRect, paint);
      }
    }
  }

  void _outerCircle(Size size, Canvas canvas, double scaledRadius) {
    final outerCirclePaint = Paint()
      ..style = PaintingStyle.stroke
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
  bool shouldRepaint(VisualizerPainter oldDelegate) => true;
}
