import 'package:waveglow/features/home/home_exports.dart';

abstract class HomeVisualizerPlatformDataSource {
  Future<Stream<List<double>>> getOutPutAudioStream();
  Future<Stream<VisualizerBandsModel>> getPerceptualBandsStream();
}
