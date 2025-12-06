import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences _sharedPreferences;
  @visibleForTesting
  final String themeKey = "settings_theme_mode";

  SettingsDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveSettings(SettingsSaveParams params) async {
    await _sharedPreferences.setInt(themeKey, params.themeMode.index);
  }

  @override
  Future<SettingsModel> getSavedData() async {
    final themeModeIndex = _sharedPreferences.getInt(themeKey);

    return SettingsModel(
      themeMode: themeModeIndex != null ? ThemeMode.values[themeModeIndex] : ThemeMode.dark,
    );
  }
}
