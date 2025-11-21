import 'package:waveglow/features/music_player/music_player_exports.dart';

abstract class MusicPlayerDataSource {
  Future<void> saveCurrentPlayList(MusicPlayerPlayListModel model);
  Future<MusicPlayerPlayListModel> getLastSavedPlaylist();
  Future<void> saveMediaControls(MusicPlayerSaveControlsParam params);
  Future<MusicPlayerControlsEntity> getMediaControls();
}
