import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> mainInjections() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(sharedPreferences);
}
