import 'package:waveglow/features/visualizer/visualizer_exports.dart';

abstract class VisualizerPlatformDataSource {
  Future<Stream<List<double>>> getFrequenciesStream();
  Future<Stream<VisualizerFrequencyBandsModel>> getFrequencyBandsStream();
}
