import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsStateController extends GetxController {
  final SettingsService _settingsService;
  final CustomDialogs _customDialogs;

  final _settings = Rx<SettingsEntity?>(null);

  SettingsStateController({
    required SettingsService settingsService,
    required CustomDialogs customDialogs,
  }) : _settingsService = settingsService,
       _customDialogs = customDialogs;

  SettingsEntity? get settings => _settings.value;

  @override
  void onInit() {
    super.onInit();
    getSavedData();
  }

  Future<void> getSavedData() async {
    final result = await _settingsService.getSavedData();

    result.fold(
      (failure) => _customDialogs.showFailure(failure),
      (settings) => _settings.value = settings,
    );
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    final params = SettingsSaveParams(themeMode: themeMode);

    final result = await _settingsService.saveSettings(params);

    result.fold(
      (failure) {
        _customDialogs.showFailure(failure);
      },
      (_) {
        getSavedData();
        Get.changeThemeMode(themeMode);
      },
    );
  }
}
