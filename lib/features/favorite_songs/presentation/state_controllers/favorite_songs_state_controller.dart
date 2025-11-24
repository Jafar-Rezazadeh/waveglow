import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class FavoriteSongsStateController extends GetxController {
  final TracksListService _tracksListService;
  final MusicPlayerService _musicPlayerService;
  final CustomDialogs _customDialogs;

  final favoriteSongsPlayListId = "favorite_songs_id";

  final _allFavoriteSongs = RxList<AudioItemEntity>([]);

  List<AudioItemEntity> get allFavoriteSongs => _allFavoriteSongs;

  // TODO: test getting favorite song as Stream (bcs we need to refresh every time a favorite button is toggle)

  FavoriteSongsStateController({
    required TracksListService tracksListService,
    required MusicPlayerService musicPlayerService,
    required CustomDialogs customDialogs,
  }) : _tracksListService = tracksListService,
       _musicPlayerService = musicPlayerService,
       _customDialogs = customDialogs;

  @override
  void onInit() {
    super.onInit();
    getFavoriteSongs();
  }

  Future<void> getFavoriteSongs() async {
    final result = await _tracksListService.getFavoriteSongs();

    result.fold(
      (failure) => _customDialogs.showFailure(failure),
      (data) => _allFavoriteSongs.value = data,
    );
  }

  Future<void> playTrack(AudioItemEntity item) async {
    if (_musicPlayerService.currentPlaylist?.id != favoriteSongsPlayListId) {
      await _musicPlayerService.openPlayList(
        MusicPlayerPlayListEntity(id: favoriteSongsPlayListId, audios: _allFavoriteSongs),
      );
    }

    final index =
        _musicPlayerService.currentPlaylist?.audios.indexWhere((e) => e.path == item.path) ?? -1;

    if (index != -1) {
      await _musicPlayerService.playAt(index);
    }
  }
}
