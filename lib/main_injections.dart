import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_injection.dart';
import 'package:waveglow/features/tracks_list/tracks_list_injections.dart';

Future<void> mainInjections() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  await initTracksListInjections();
  final musicPlayerService = await initMusicPlayerInjections();
  _initMainService(musicPlayerService);
}

void _initMainService(MusicPlayerService musicPlayerService) {
  Get.put(MainService(musicPlayerService: musicPlayerService));
}
