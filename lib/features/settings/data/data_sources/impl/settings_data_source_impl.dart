import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences _sharedPreferences;
  @visibleForTesting
  final String themeKey = "settings_theme_mode";
  final String languageKey = "settings_language_mode";

  SettingsDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  @override
  Future<void> saveSettings(SettingsSaveParams params) async {
    if (params.themeMode != null) {
      await _sharedPreferences.setInt(themeKey, params.themeMode!.index);
    }

    if (params.language != null) {
      await _sharedPreferences.setInt(languageKey, params.language!.index);
    }
  }

  @override
  Future<SettingsModel> getSavedData() async {
    final themeModeIndex = _sharedPreferences.getInt(themeKey);
    final languageIndex = _sharedPreferences.getInt(languageKey);

    return SettingsModel(
      themeMode: themeModeIndex != null ? ThemeMode.values[themeModeIndex] : ThemeMode.dark,
      languageEnum: languageIndex != null
          ? LanguageEnum.values[languageIndex]
          : LanguageEnum.english,
    );
  }
}
