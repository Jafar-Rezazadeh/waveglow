import 'package:waveglow/features/home/home_exports.dart';

abstract class VisualizerPlatformDataSource {
  Future<Stream<List<double>>> getOutPutAudioStream();
  Future<Stream<VisualizerBandsModel>> getPerceptualBandsStream();
}
