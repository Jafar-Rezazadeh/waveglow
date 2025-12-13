import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/music_player/music_player_injection.dart';
import 'package:waveglow/features/settings/settings_service_injection.dart';
import 'package:waveglow/features/tracks_list/tracks_list_injections.dart';

Future<void> mainInjections() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put(sharedPreferences);

  await initTracksListInjections();
  final musicPlayerService = await initMusicPlayerInjections();
  final settingsService = initSettingsInjection();
  _initMainService(musicPlayerService, settingsService);
}

void _initMainService(MusicPlayerService musicPlayerService, SettingsService settingsService) {
  Get.put(MainService(musicPlayerService: musicPlayerService, settingsService: settingsService));
}
