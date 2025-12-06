import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/settings/settings_export.dart';

SettingsService initSettingsInjection() {
  // extras
  final sharedPreferences = Get.find<SharedPreferences>();

  // dataSources
  final settingsDataSource = SettingsDataSourceImpl(sharedPreferences: sharedPreferences);

  // repositories
  final repository = SettingsRepositoryImpl(
    settingsDataSource: settingsDataSource,
    failureFactory: FailureFactory(),
  );

  // useCase
  final getSavedDataUC = SettingsGetSavedDataUC(repository: repository);
  final settingsSaveUC = SettingsSaveUC(repository: repository);

  return Get.put<SettingsService>(
    SettingsServiceImpl(getSavedDataUC: getSavedDataUC, settingsSaveUC: settingsSaveUC),
  );
}
