import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/services/main_service.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    final audioPlayer = Player();

    Get.put(
      MainService(audioPlayer: audioPlayer),
    );
  }
}
