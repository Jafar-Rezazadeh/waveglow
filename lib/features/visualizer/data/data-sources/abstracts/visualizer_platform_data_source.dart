import 'package:waveglow/features/visualizer/visualizer_exports.dart';

abstract class VisualizerPlatformDataSource {
  Future<Stream<List<double>>> getOutPutAudioStream();
  Future<Stream<VisualizerBandsModel>> getPerceptualBandsStream();
}
