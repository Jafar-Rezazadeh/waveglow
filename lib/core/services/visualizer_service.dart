import 'package:waveglow/features/visualizer/visualizer_exports.dart';

abstract class VisualizerService {
  Stream<VisualizerFrequencyBandsEntity> get bandsStream;

  Future<void> start();
  Future<void> stop();
}
