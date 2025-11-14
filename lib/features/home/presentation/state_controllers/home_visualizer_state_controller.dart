import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/services/music_player_service.dart';
import 'package:waveglow/features/home/home_exports.dart';
import 'package:waveglow/services/home_audio_bands_service.dart';

class _CustomTicker extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class HomeVisualizerStateController extends GetxController {
  final HomeAudioBandsService _audioBandsService;
  late final Ticker _ticker;
  late final _musicPlayer = Get.find<MusicPlayerService>();
  @visibleForTesting
  StreamSubscription<HomeVisualizerBandsEntity>? bandsStreamSub;

  HomeVisualizerStateController({
    required HomeAudioBandsService audioBandsService,
    StreamSubscription<HomeVisualizerBandsEntity>? mockStreamSub,
  }) : _audioBandsService = audioBandsService,
       bandsStreamSub = mockStreamSub;

  final _perceptualBands = Rx<HomeVisualizerBandsEntity?>(null);
  late final _smoothedPerceptualBands = Rx<HomeVisualizerBandsEntity>(_initBandsValue);
  final _initBandsValue = HomeVisualizerBandsEntity(
    subBass: 0,
    bass: 0,
    lowMid: 0,
    mid: 0,
    highMid: 0,
    presence: 0,
    brilliance: 0,
    loudness: 0,
  );

  HomeVisualizerBandsEntity get smoothedPerceptualBands => _smoothedPerceptualBands.value;
  @visibleForTesting
  HomeVisualizerBandsEntity? get perceptualBands => _perceptualBands.value;

  @visibleForTesting
  set setPerceptualBands(HomeVisualizerBandsEntity value) => _perceptualBands.value = value;

  @override
  void onInit() {
    super.onInit();
    _setTicker();
    _musicPlayer.isPlayingStream.listen((isPlaying) {
      if (isPlaying) {
        startListeningBandsSpectrum();
      } else {
        stopListeningBandsSpectrum();
      }
    });
  }

  void _setTicker() {
    _ticker = _CustomTicker().createTicker((elapsed) {
      _smoothedPerceptualBands.value = _smoothBands(
        previous: _smoothedPerceptualBands.value,
        current: _perceptualBands.value,
        attack: 0.3,
        decay: 0.10,
      );
    });

    _ticker.start();
  }

  @override
  void dispose() {
    stopListeningBandsSpectrum();
    _ticker.dispose();
    super.dispose();
  }

  @visibleForTesting
  Future<void> startListeningBandsSpectrum() async {
    await _audioBandsService.start();

    bandsStreamSub = _audioBandsService.bandsStream.listen((event) {
      _perceptualBands.value = event;
    });
  }

  @visibleForTesting
  Future<void> stopListeningBandsSpectrum() async {
    bandsStreamSub?.cancel();
    bandsStreamSub = null;
    await _audioBandsService.stop();
    _perceptualBands.value = HomeVisualizerBandsEntity(
      subBass: 0,
      bass: 0,
      lowMid: 0,
      mid: 0,
      highMid: 0,
      presence: 0,
      brilliance: 0,
      loudness: 0,
    );
  }

  HomeVisualizerBandsEntity _smoothBands({
    required HomeVisualizerBandsEntity previous,
    HomeVisualizerBandsEntity? current, // nullable
    double attack = 0.3,
    double decay = 0.05,
  }) {
    // faster fade when the incoming band value is explicitly zero,
    // and clamp very small values to 0 to avoid deNormals.
    double smooth(double prev, double? cur) {
      const double eps = 1e-8; // threshold to clamp tiny values
      if (cur == null) return prev;

      // If the current measurement is explicitly zero, fade previous towards zero
      // slowly so the visualizer goes to silence more gently.
      if (cur == 0.0) {
        const double silenceDecayMultiplier = 0.2; // <1 to slow the decay (tweak as needed)
        final double silenceDecayFactor = (decay * silenceDecayMultiplier).clamp(0.0, 1.0);
        final double next = prev * (1.0 - silenceDecayFactor);
        if (next.abs() < eps) return 0.0;
        return next;
      }

      // Normal smoothing: attack for rising values, decay for falling values.
      if (cur > prev) {
        final double next = prev * (1 - attack) + cur * attack;
        if (next.abs() < eps) return 0.0;
        return next;
      }

      final double next = prev * (1 - decay) + cur * decay;
      if (next.abs() < eps) return 0.0;
      return next;
    }

    return HomeVisualizerBandsEntity(
      subBass: smooth(previous.subBass, current?.subBass),
      bass: smooth(previous.bass, current?.bass),
      lowMid: smooth(previous.lowMid, current?.lowMid),
      // mid: smooth(previous.mid, current?.mid),
      // highMid: smooth(previous.highMid, current?.highMid),
      // presence: smooth(previous.presence, current?.presence),
      // brilliance: smooth(previous.brilliance, current?.brilliance),
      loudness: smooth(previous.loudness, current?.loudness),
      mid: current?.mid ?? 0,
      highMid: current?.highMid ?? 0,
      presence: current?.presence ?? 0,
      brilliance: current?.brilliance ?? 0,
      // loudness: current?.loudness ?? 0,
    );
  }
}
