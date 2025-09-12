import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/services/music_player_service.dart';
import 'package:waveglow/features/home/home_exports.dart';

class _CustomTicker extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class HomeVisualizerStateController extends GetxController {
  final GetHomeVisualizerPerceptualBandsStreamUC _getVisualizerLiveBandsUC;
  late final Ticker _ticker;

  late final _musicPlayer = Get.find<MusicPlayerService>();

  HomeVisualizerStateController({
    required GetHomeVisualizerPerceptualBandsStreamUC getVisualizerPerceptualBandsStreamUC,
  }) : _getVisualizerLiveBandsUC = getVisualizerPerceptualBandsStreamUC;

  StreamSubscription<HomeVisualizerBandsEntity>? _perceptualBandsStream;

  final _perceptualBands = Rx<HomeVisualizerBandsEntity?>(null);
  final _smoothedPerceptualBands = Rx<HomeVisualizerBandsEntity>(
    HomeVisualizerBandsEntity(
      subBass: 0,
      bass: 0,
      lowMid: 0,
      mid: 0,
      highMid: 0,
      presence: 0,
      brilliance: 0,
      loudness: 0,
    ),
  );

  HomeVisualizerBandsEntity get smoothedPerceptualBands => _smoothedPerceptualBands.value;

  @override
  void onInit() {
    super.onInit();
    _setTicker();
    _musicPlayer.isPlayingStream.listen(
      (isPlaying) {
        if (isPlaying) {
          startListeningToAudio();
        } else {
          stopListeningToAudio();
        }
      },
    );
  }

  void _setTicker() {
    _ticker = _CustomTicker().createTicker(
      (elapsed) {
        _smoothedPerceptualBands.value =
            _smoothBands(previous: _smoothedPerceptualBands.value, current: _perceptualBands.value);
      },
    );

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> startListeningToAudio() async {
    final bandsResult = await _getVisualizerLiveBandsUC.call(NoParams());

    bandsResult.fold(
      (failure) => debugPrint(failure.message),
      (stream) {
        _perceptualBandsStream = stream.listen(
          (event) {
            _perceptualBands.value = event;
          },
        );
      },
    );
  }

  void stopListeningToAudio() {
    _perceptualBandsStream?.cancel();
    _perceptualBandsStream = null;
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
}
