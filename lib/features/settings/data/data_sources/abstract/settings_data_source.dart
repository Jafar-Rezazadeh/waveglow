import 'package:waveglow/features/settings/settings_export.dart';

abstract class SettingsDataSource {
  Future<void> saveSettings(SettingsSaveParams params);
  Future<SettingsModel> getSavedData();
}
