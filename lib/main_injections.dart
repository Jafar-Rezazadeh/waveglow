import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/features/tracks_list/tracks_list_injections.dart';

Future<void> mainInjections() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(sharedPreferences);

  await initTracksListInjections();
}
