import 'package:waveglow/features/music_player/data/models/music_player_play_list_model.dart';

abstract class MusicPlayerDataSource {
  Future<void> saveCurrentPlayList(MusicPlayerPlayListModel model);
}
