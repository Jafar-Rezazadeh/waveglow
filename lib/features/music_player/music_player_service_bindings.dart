import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/services/music_player_service.dart';
import 'package:waveglow/features/music_player/services/music_player_service_impl.dart';

class MusicPlayerServiceBindings extends Bindings {
  @override
  void dependencies() {
    // extras
    final player = Player();

    // services
    Get.put<MusicPlayerService>(
      MusicPlayerServiceImpl(player: player),
    );
  }
}
