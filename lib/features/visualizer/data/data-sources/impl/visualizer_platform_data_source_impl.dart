import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class VisualizerPlatformDataSourceImpl implements VisualizerPlatformDataSource {
  @visibleForTesting
  final eventChannel = const EventChannel("com.waveglow.eventChannel/live_audio_fft");

  @override
  Future<Stream<List<double>>> getOutPutAudioStream() async {
    return eventChannel.receiveBroadcastStream().map((event) => (event as List).cast<double>());
  }
}
