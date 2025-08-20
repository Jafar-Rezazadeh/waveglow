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
    double attack = 0.3,
    double decay = 0.1,
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

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.perceptualBands,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (perceptualBands != null) {
      _outerCircle(size, canvas, perceptualBands!.bass * 100);
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
