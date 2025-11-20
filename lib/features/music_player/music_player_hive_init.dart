import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

Future<void> initMusicPlayerHive() async {
  Hive.registerAdapter(MusicPlayerPlayListModelAdapter());
  await Hive.openBox<MusicPlayerPlayListModel>(HiveBoxesName.musicPlayer);
}
