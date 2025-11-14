import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/home/home_exports.dart';
import 'package:waveglow/services/home_audio_bands_service.dart';

class HomeAudioBandsServiceImpl extends GetxService implements HomeAudioBandsService {
  final GetHomeVisualizerPerceptualBandsStreamUC _getBandsStreamUC;
  StreamSubscription<HomeVisualizerBandsEntity>? _streamSubscription;
  final _streamController = StreamController<HomeVisualizerBandsEntity>.broadcast();

  HomeAudioBandsServiceImpl({required GetHomeVisualizerPerceptualBandsStreamUC getBandsStreamUC})
    : _getBandsStreamUC = getBandsStreamUC;

  @override
  Stream<HomeVisualizerBandsEntity> get bandsStream => _streamController.stream;

  @override
  Future<void> start() async {
    final bandsResult = await _getBandsStreamUC.call(NoParams());

    bandsResult.fold((failure) => debugPrint(failure.message), (stream) {
      _streamSubscription = stream.listen((event) {
        _streamController.add(event);
      });
    });
  }

  @override
  Future<void> stop() async {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  @override
  Future<void> onClose() async {
    await _streamController.close();
    super.onClose();
  }
}
