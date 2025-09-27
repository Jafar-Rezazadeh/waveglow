import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/home/home_exports.dart';

class HomeVisualizerWidget extends StatelessWidget {
  HomeVisualizerWidget({super.key});

  final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<HomeVisualizerStateController>();
  late final _musicPlayer = Get.find<MusicPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomPaint(
        painter: VisualizerPainter(
          colorPalette: _colorPalette,
          perceptualBands: _controller.smoothedPerceptualBands,
          circleRadius: 110,
        ),
        child: _musicPlayer.currentMusicMetaData?.albumArt != null
            ? CircleAvatar(
                radius: 106,
                backgroundColor: _colorPalette.background,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(1000),
                  child: Image.memory(
                    _musicPlayer.currentMusicMetaData!.albumArt!,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// Particle class for visualizer
class _Particle {
  Offset position;
  Offset velocity;
  Color color;
  double life;
  double size;
  _Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.life,
    required this.size,
  });
}

class VisualizerPainter extends CustomPainter {
  // Simple particle system: particles move from center to edges
  static final List<_Particle> _particles = [];
  static int _lastTick = 0;
  static int _lastParticleSpawn = 0;
  final particleCount = 15;

  // Particle class
  final AppColorPalette colorPalette;
  final HomeVisualizerBandsEntity perceptualBands;
  final double circleRadius;

  VisualizerPainter({
    super.repaint,
    required this.colorPalette,
    required this.perceptualBands,
    this.circleRadius = 110,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawParticles(canvas, size);
    _fullWaveCircleWithAmplitudeBumps(size, canvas, circleRadius);
    _baseCircle(size, canvas, circleRadius);
  }

  void _drawParticles(Canvas canvas, Size size) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dt = (_lastTick == 0) ? 0.016 : (now - _lastTick) / 1000.0;
    _lastTick = now;

    final center = Offset(size.width / 2, size.height / 2);

    // Emit new particles continuously at a fixed interval (e.g., every 80ms)
    const spawnIntervalMs = 200;
    if (now - _lastParticleSpawn > spawnIntervalMs &&
        perceptualBands.loudness > 0) {
      _lastParticleSpawn = now;
      for (int i = 0; i < particleCount; i++) {
        final angle = Random().nextDouble() * 2 * pi;
        final speed = 80.0 * Random().nextDouble() * 1.1;
        // const speed = 80.0;
        final size = 2 + Random().nextDouble() * 3;
        _particles.add(
          _Particle(
            position: center,
            velocity: Offset(cos(angle), sin(angle)) * speed,
            color: colorPalette.neutral50,
            life: 3,
            size: size,
          ),
        );
      }
    }

    // Update and draw particles
    final loudnessBoost = (perceptualBands.loudness > 0.04
        ? perceptualBands.loudness * 40
        : perceptualBands.loudness * 30);

    for (final p in _particles) {
      p.position += p.velocity * dt * loudnessBoost;
      p.life -= dt * 0.7;
    }

    // Remove particles that are dead
    _particles.removeWhere((p) => p.life <= 0);

    for (final p in _particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.life.clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(p.position, p.size, paint);
    }
  }

  void _fullWaveCircleWithAmplitudeBumps(
      Size size, Canvas canvas, double circleRadius) {
    // bumpAngles sum should be 1
    final fullBass = (perceptualBands.bass * perceptualBands.subBass);

    final List<({double amplitude, double bumpAngle})> bumpDatas = [
      (
        amplitude: fullBass * 170,
        bumpAngle: pi * 0.4,
      ),
      (
        amplitude: (perceptualBands.mid * perceptualBands.lowMid) * 300,
        bumpAngle: pi * 0.1,
      ),
      (
        amplitude: (perceptualBands.highMid) * 100,
        bumpAngle: pi * 0.2,
      ),
      (
        amplitude: (perceptualBands.presence) * 100,
        bumpAngle: pi * 0.15,
      ),
      (
        amplitude: perceptualBands.brilliance * 300,
        bumpAngle: pi * 0.16,
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
      double localAngle =
          (angle - startAngle) / bumpDatas[bumpIndex].bumpAngle * pi;
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
      double localAngle =
          (mirroredAngle - startAngle) / bumpDatas[bumpIndex].bumpAngle * pi;
      double r = circleRadius + sin(localAngle) * amp;

      double x = center.dx + r * cos(angle + angleOffset);
      double y = center.dy + r * sin(angle + angleOffset);

      path.lineTo(x, y);
    }

    path.close();

    // gloving shadow
    final loudnessScaled =
        (perceptualBands.loudness * 1000).clamp(0, 255).toInt();

    final shadowColor = colorPalette.surface.withAlpha(loudnessScaled);

    canvas.save();
    canvas.translate(0, -loudnessScaled.toDouble() / 3);
    canvas.drawShadow(
      path,
      shadowColor,
      loudnessScaled.toDouble().clamp(0, 50),
      false,
    );
    canvas.drawShadow(
      path,
      shadowColor,
      loudnessScaled.toDouble().clamp(0, 50),
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
      ..color = colorPalette.neutral50.withValues(alpha: 0.2)
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
  bool shouldRepaint(VisualizerPainter oldDelegate) =>
      oldDelegate.perceptualBands != perceptualBands;
}
