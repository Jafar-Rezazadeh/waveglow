import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/services/music_player_service.dart';
import 'package:waveglow/core/theme/color_palette.dart';
import 'package:waveglow/features/home/home_exports.dart';

class HomeVisualizerWidget extends StatefulWidget {
  const HomeVisualizerWidget({super.key});

  @override
  State<HomeVisualizerWidget> createState() => _HomeVisualizerWidgetState();
}

class _HomeVisualizerWidgetState extends State<HomeVisualizerWidget>
    with SingleTickerProviderStateMixin {
  final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  late final _controller = Get.find<HomeVisualizerStateController>();
  late final _musicPlayer = Get.find<MusicPlayerService>();

  late final Ticker _ticker;
  HomeVisualizerBandsEntity smoothedBands = HomeVisualizerBandsEntity(
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
    _musicPlayer.open(Media('F:/projects/Flutter/CrossPlatform/waveglow/test_music.mp3'));
    _setTicker();
  }

  void _setTicker() {
    _ticker = createTicker((elapsed) {
      final currentBands = _controller.perceptualBands; // the latest values from your EventChannel

      smoothedBands = smoothBands(previous: smoothedBands, current: currentBands);

      setState(() {});
    });
    _ticker.start();
  }

  HomeVisualizerBandsEntity smoothBands({
    required HomeVisualizerBandsEntity previous,
    HomeVisualizerBandsEntity? current, // nullable
    double attack = 0.4,
    double decay = 0.05,
  }) {
    double smooth(double prev, double? cur) {
      if (cur == null) return prev;
      if (cur > prev) return prev * (1 - attack) + cur * attack;
      return prev * (1 - decay) + cur * decay;
    }

    return HomeVisualizerBandsEntity(
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
          size: const Size(300, 300),
          painter: VisualizerPainter(
            colorPalette: _colorPalette,
            perceptualBands: smoothedBands,
          ),
        ),
        TextButton(
          onPressed: () async {
            _musicPlayer.playOrPause();
            _controller.startListeningToAudio();
          },
          child: const Text("start"),
        ),
        TextButton(
          onPressed: () {
            _musicPlayer.playOrPause();
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
  final HomeVisualizerBandsEntity? perceptualBands;
  final double circleRadius;

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.perceptualBands,
    this.circleRadius = 110,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (perceptualBands != null) {
      _fullDynamicWaveCircle(size, canvas, circleRadius);
      _baseCircle(size, canvas, circleRadius);
    }
  }

  void _fullDynamicWaveCircle(Size size, Canvas canvas, double circleRadius) {
    // bumpAngles sum should be 1
    final fullBass = (perceptualBands!.bass * perceptualBands!.subBass);

    final List<({double amplitude, double bumpAngle})> bumpDatas = [
      (
        amplitude: fullBass * 170,
        bumpAngle: pi * 0.5,
      ),
      (
        amplitude: perceptualBands!.lowMid * 50,
        bumpAngle: pi * 0.2,
      ),
      (
        amplitude: (perceptualBands!.mid * perceptualBands!.highMid) * 200,
        bumpAngle: pi * 0.2,
      ),
      (
        amplitude: perceptualBands!.presence * 200,
        bumpAngle: pi * 0.3,
      ),
    ];

    final path = Path();
    final paint = Paint()
      ..color = colorPalette.neutral50
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    const double angleOffset = -pi / 2; // start at top

    // Precompute cumulative angles for easier lookup
    List<double> cumulativeAngles = [];
    double sum = 0;
    for (double a in bumpDatas.map((e) => e.bumpAngle)) {
      sum += a;
      cumulativeAngles.add(sum);
    }

    double angleStep = 0.001; // small step for smoothness

    // Half circle: 0 -> pi
    for (double angle = 0; angle <= pi + 0.01; angle += angleStep) {
      // Find which bump this angle is in
      int bumpIndex = 0;
      for (int i = 0; i < cumulativeAngles.length; i++) {
        if (angle <= cumulativeAngles[i]) {
          bumpIndex = i;
          break;
        }
      }
      double amp = bumpDatas[bumpIndex].amplitude;

      // Compute local angle inside this bump for sine wave
      double startAngle = bumpIndex == 0 ? 0 : cumulativeAngles[bumpIndex - 1];
      double localAngle = (angle - startAngle) / bumpDatas[bumpIndex].bumpAngle * pi;
      double r = circleRadius + sin(localAngle) * amp;

      double x = center.dx + r * cos(angle + angleOffset);
      double y = center.dy + r * sin(angle + angleOffset);

      if (angle == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Mirror second half (π -> 2π)
    for (double angle = pi; angle <= 2 * pi + 0.01; angle += angleStep) {
      double mirroredAngle = 2 * pi - angle;

      int bumpIndex = 0;
      for (int i = 0; i < cumulativeAngles.length; i++) {
        if (mirroredAngle <= cumulativeAngles[i]) {
          bumpIndex = i;
          break;
        }
      }

      double amp = bumpDatas[bumpIndex].amplitude;

      double startAngle = bumpIndex == 0 ? 0 : cumulativeAngles[bumpIndex - 1];
      double localAngle = (mirroredAngle - startAngle) / bumpDatas[bumpIndex].bumpAngle * pi;
      double r = circleRadius + sin(localAngle) * amp;

      double x = center.dx + r * cos(angle + angleOffset);
      double y = center.dy + r * sin(angle + angleOffset);

      path.lineTo(x, y);
    }

    path.close();

    // gloving shadow
    final fullBaseScaled = (fullBass * 1000).clamp(0, 255).toInt();

    final shadowColor = colorPalette.surface.withAlpha(fullBaseScaled);

    canvas.save();
    canvas.translate(0, -fullBaseScaled.toDouble() / 4);
    canvas.drawShadow(
      path,
      shadowColor,
      fullBaseScaled.toDouble().clamp(0, 50),
      false,
    );
    canvas.drawShadow(
      path,
      shadowColor,
      fullBaseScaled.toDouble().clamp(0, 50),
      false,
    );
    canvas.restore();

    canvas.drawPath(path, paint);
  }

  void _baseCircle(Size size, Canvas canvas, double scaledRadius) {
    final outerBorderCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = colorPalette.neutral50
      ..strokeWidth = 5;

    final innerCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = colorPalette.background
      ..strokeWidth = 2;

    final shadowPaint = Paint()
      ..color = colorPalette.neutral50.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(size.center(Offset.zero), scaledRadius + 2, shadowPaint);
    canvas.drawCircle(size.center(Offset.zero), scaledRadius, innerCirclePaint);

    canvas.drawCircle(
      size.center(Offset.zero),
      circleRadius - 2,
      outerBorderCirclePaint,
    );
  }

  @override
  bool shouldRepaint(VisualizerPainter oldDelegate) => true;
}
