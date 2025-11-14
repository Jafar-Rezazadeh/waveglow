import 'package:waveglow/features/home/home_exports.dart';

abstract class HomeAudioBandsService {
  Stream<HomeVisualizerBandsEntity> get bandsStream;

  Future<void> start();
  Future<void> stop();
}
