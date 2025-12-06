import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/settings/presentation/state_controllers/settings_state_controller.dart';

class SettingsPageBindings extends Bindings {
  @override
  void dependencies() {
    final settingsService = Get.find<SettingsService>();

    Get.put(
      SettingsStateController(settingsService: settingsService, customDialogs: CustomDialogs()),
    );
  }
}
