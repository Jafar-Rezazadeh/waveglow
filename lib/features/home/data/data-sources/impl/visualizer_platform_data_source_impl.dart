import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:waveglow/features/home/home_exports.dart';

class VisualizerPlatformDataSourceImpl implements VisualizerPlatformDataSource {
  @visibleForTesting
  final eventChannel = const EventChannel("com.waveglow.eventChannel/live_audio_fft");

  @override
  Future<Stream<List<double>>> getOutPutAudioStream() async {
    return eventChannel
        .receiveBroadcastStream("all-bars")
        .map((event) => (event as List).cast<double>());
  }

  @override
  Future<Stream<VisualizerBandsModel>> getPerceptualBandsStream() async {
    return eventChannel
        .receiveBroadcastStream("perceptual-bands")
        .map((map) => VisualizerBandsModel.fromMap(map));
  }
}
