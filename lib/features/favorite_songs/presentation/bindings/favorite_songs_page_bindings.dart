import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/favorite_songs/presentation/state_controllers/favorite_songs_state_controller.dart';

class FavoriteSongsPageBindings extends Bindings {
  @override
  void dependencies() {
    // extras
    final tracksListService = Get.find<TracksListService>();
    final musicPlayerService = Get.find<MusicPlayerService>();

    // controllers
    Get.put(
      FavoriteSongsStateController(
        tracksListService: tracksListService,
        customDialogs: CustomDialogs(),
        musicPlayerService: musicPlayerService,
      ),
    );
  }
}
