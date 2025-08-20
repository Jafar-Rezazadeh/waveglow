import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerStateController extends GetxController {
  final GetVisualizerPerceptualBandsStreamUC _getVisualizerLiveBandsUC;

  VisualizerStateController({
    required GetVisualizerPerceptualBandsStreamUC getVisualizerPerceptualBandsStreamUC,
  }) : _getVisualizerLiveBandsUC = getVisualizerPerceptualBandsStreamUC;

  StreamSubscription<VisualizerBandsEntity>? _perceptualBandsStream;

  final _perceptualBands = Rx<VisualizerBandsEntity?>(null);

  VisualizerBandsEntity? get perceptualBands => _perceptualBands.value;

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
    _perceptualBands.value = null;
  }
}
