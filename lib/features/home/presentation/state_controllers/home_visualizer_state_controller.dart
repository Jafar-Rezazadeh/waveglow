import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/home/home_exports.dart';

class HomeVisualizerStateController extends GetxController {
  final GetHomeVisualizerPerceptualBandsStreamUC _getVisualizerLiveBandsUC;

  HomeVisualizerStateController({
    required GetHomeVisualizerPerceptualBandsStreamUC getVisualizerPerceptualBandsStreamUC,
  }) : _getVisualizerLiveBandsUC = getVisualizerPerceptualBandsStreamUC;

  StreamSubscription<HomeVisualizerBandsEntity>? _perceptualBandsStream;

  final _perceptualBands = Rx<HomeVisualizerBandsEntity?>(null);

  HomeVisualizerBandsEntity? get perceptualBands => _perceptualBands.value;

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
}
