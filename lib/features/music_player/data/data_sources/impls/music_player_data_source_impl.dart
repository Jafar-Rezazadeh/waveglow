import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class MusicPlayerDataSourceImpl implements MusicPlayerDataSource {
  final Box<MusicPlayerPlayListModel> _musicPlayerBox;
  final String _key = "play_list";

  MusicPlayerDataSourceImpl({Box<MusicPlayerPlayListModel>? testMusicPlayerBox})
    : _musicPlayerBox =
          testMusicPlayerBox ?? Hive.box<MusicPlayerPlayListModel>(HiveBoxesName.musicPlayer);

  @override
  Future<void> saveCurrentPlayList(MusicPlayerPlayListModel model) async {
    await _musicPlayerBox.put(_key, model);
  }
}
