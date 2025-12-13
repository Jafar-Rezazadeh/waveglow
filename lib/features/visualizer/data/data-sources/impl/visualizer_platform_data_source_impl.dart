import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerPlatformDataSourceImpl implements VisualizerPlatformDataSource {
  @visibleForTesting
  final eventChannel = const EventChannel("com.waveglow.eventChannel/live_audio_fft");

  @override
  Future<Stream<List<double>>> getFrequenciesStream() async {
    return eventChannel
        .receiveBroadcastStream("all-bars")
        .map((event) => (event as List).cast<double>());
  }

  @override
  Future<Stream<VisualizerFrequencyBandsModel>> getFrequencyBandsStream() async {
    return eventChannel
        .receiveBroadcastStream("perceptual-bands")
        .map((map) => VisualizerFrequencyBandsModel.fromMap(map));
  }
}
