import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerServiceBindings extends Bindings {
  @override
  void dependencies() {
    // extras
    final player = Player();

    // data-source
    final musicPlayerDataSource = MusicPlayerDataSourceImpl();

    // repositories
    final repository = MusicPlayerRepositoryImpl(
      failureFactory: FailureFactory(),
      musicPlayerDataSource: musicPlayerDataSource,
    );

    // useCases
    final saveCurrentPlayListUC = MusicPlayerSaveCurrentPlayListUC(repository: repository);
    final getLastSavedPlaylistUC = MusicPlayerGetLastSavedPlaylistUC(repository: repository);

    // services
    Get.put<MusicPlayerService>(
      MusicPlayerServiceImpl(
        player: player,
        saveCurrentPlayListUC: saveCurrentPlayListUC,
        getLastSavedPlaylistUC: getLastSavedPlaylistUC,
        logger: Logger(),
      ),
    );
  }
}
