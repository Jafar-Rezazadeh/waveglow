import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/visualizer/domain/use_cases/visualizer_get_live_output_audio_stream.dart';

class VisualizerStateController extends GetxController {
  final VisualizerGetLiveOutPutAudioStreamUC _getLiveOutPutAudioStreamUC;

  VisualizerStateController({
    required VisualizerGetLiveOutPutAudioStreamUC getLiveOutPutAudioStreamUC,
  }) : _getLiveOutPutAudioStreamUC = getLiveOutPutAudioStreamUC;

  StreamSubscription<List<double>>? _liveAudio64Bar;

  final _magnitudes = Rx<List<double>>([]);

  List<double> get magnitudes => _magnitudes.value;

  Future<void> startListeningToAudio() async {
    final result = await _getLiveOutPutAudioStreamUC.call(NoParams());

    result.fold(
      (failure) => debugPrint(failure.message),
      (stream) {
        _liveAudio64Bar = stream.listen(
          (event) {
            _magnitudes.value = event;
          },
        );
      },
    );
  }

  void stopListeningToAudio() {
    _magnitudes.value = [];
    _liveAudio64Bar?.cancel();
    _liveAudio64Bar = null;
  }
}
