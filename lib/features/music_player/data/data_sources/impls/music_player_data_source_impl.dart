import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerDataSourceImpl implements MusicPlayerDataSource {
  final Box<MusicPlayerPlayListModel> _musicPlayerBox;
  final SharedPreferences _sharedPreferences;
  final String _playlistKey = "play_list";
  final String _volumeKey = "volume";
  final String _playlistModeKey = "playlist_mode";

  MusicPlayerDataSourceImpl({
    Box<MusicPlayerPlayListModel>? testMusicPlayerBox,
    required SharedPreferences sharedPreferences,
  }) : _musicPlayerBox =
           testMusicPlayerBox ?? Hive.box<MusicPlayerPlayListModel>(HiveBoxEnum.musicPlayer.value),
       _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveCurrentPlayList(MusicPlayerPlayListModel model) async {
    await _musicPlayerBox.put(_playlistKey, model);
  }

  @override
  Future<MusicPlayerPlayListModel> getLastSavedPlaylist() async {
    final result = _musicPlayerBox.get(_playlistKey);

    if (result == null) {
      throw Exception("MusicPlayer_getLastSavedPlaylist: no saved data");
    }
    return result;
  }

  @override
  Future<void> saveMediaControls(MusicPlayerSaveControlsParam params) async {
    await _sharedPreferences.setDouble(_volumeKey, params.volume);
    await _sharedPreferences.setInt(_playlistModeKey, params.playListModeIndex);
  }

  @override
  Future<MusicPlayerControlsEntity> getMediaControls() async {
    final volume = _sharedPreferences.getDouble(_volumeKey) ?? 100;
    final playlistModeIndex = _sharedPreferences.getInt(_playlistModeKey) ?? 0;

    return MusicPlayerControlsEntity(volume: volume, playlistModeIndex: playlistModeIndex);
  }
}
