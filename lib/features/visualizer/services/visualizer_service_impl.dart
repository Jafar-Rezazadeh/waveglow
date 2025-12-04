import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';
import 'package:waveglow/core/services/visualizer_service.dart';

class VisualizerServiceImpl extends GetxService implements VisualizerService {
  final GetVisualizerFrequencyBandsStreamUC _getBandsStreamUC;
  StreamSubscription<VisualizerFrequencyBandsEntity>? _streamSubscription;
  final _streamController = StreamController<VisualizerFrequencyBandsEntity>.broadcast();

  VisualizerServiceImpl({required GetVisualizerFrequencyBandsStreamUC getBandsStreamUC})
    : _getBandsStreamUC = getBandsStreamUC;

  @override
  Stream<VisualizerFrequencyBandsEntity> get bandsStream => _streamController.stream;

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
