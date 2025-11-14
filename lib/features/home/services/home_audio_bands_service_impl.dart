import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/home/home_exports.dart';
import 'package:waveglow/services/home_audio_bands_service.dart';

class HomeAudioBandsServiceImpl implements HomeAudioBandsService {
  final GetHomeVisualizerPerceptualBandsStreamUC _getBandsStreamUC;
  StreamSubscription<HomeVisualizerBandsEntity>? _streamSubscription;
  StreamController<HomeVisualizerBandsEntity>? _streamController;

  HomeAudioBandsServiceImpl({required GetHomeVisualizerPerceptualBandsStreamUC getBandsStreamUC})
    : _getBandsStreamUC = getBandsStreamUC;

  @override
  Stream<HomeVisualizerBandsEntity>? get bandsStream => _streamController?.stream;

  @override
  Future<void> start() async {
    _streamController = StreamController<HomeVisualizerBandsEntity>.broadcast();

    final bandsResult = await _getBandsStreamUC.call(NoParams());

    bandsResult.fold((failure) => debugPrint(failure.message), (stream) {
      _streamSubscription = stream.listen((event) {
        _streamController?.add(event);
      });
    });
  }

  @override
  Future<void> stop() async {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _streamController?.close();
  }
}
