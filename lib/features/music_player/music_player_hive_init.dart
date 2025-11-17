import 'package:hive/hive.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

Future<void> initMusicPlayerHive() async {
  Hive.registerAdapter(MusicPlayerPlayListModelAdapter());
}
