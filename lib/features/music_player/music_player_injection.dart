import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

Future<MusicPlayerService> initMusicPlayerInjections() async {
  // extras
  final player = Player();
  final sharedPreferences = Get.find<SharedPreferences>();

  // data-source
  final musicPlayerDataSource = MusicPlayerDataSourceImpl(sharedPreferences: sharedPreferences);

  // repositories
  final repository = MusicPlayerRepositoryImpl(
    failureFactory: FailureFactory(),
    musicPlayerDataSource: musicPlayerDataSource,
  );

  // useCases
  final saveCurrentPlayListUC = MusicPlayerSaveCurrentPlayListUC(repository: repository);
  final getLastSavedPlaylistUC = MusicPlayerGetLastSavedPlaylistUC(repository: repository);
  final saveControlsUC = MusicPlayerSaveControlsUC(repository: repository);
  final getSavedControlsUC = MusicPlayerGetSavedControlsUC(repository: repository);

  // services
  return Get.put<MusicPlayerService>(
    MusicPlayerServiceImpl(
      player: player,
      saveCurrentPlayListUC: saveCurrentPlayListUC,
      getLastSavedPlaylistUC: getLastSavedPlaylistUC,
      saveControlsUC: saveControlsUC,
      getSavedControlsUC: getSavedControlsUC,
      logger: Logger(),
    ),
  );
}
