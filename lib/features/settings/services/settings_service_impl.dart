import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsServiceImpl extends GetxService implements SettingsService  {
  final SettingsGetSavedDataUC _getSavedDataUC;
  final SettingsSaveUC _settingsSaveUC;

  SettingsServiceImpl({
    required SettingsGetSavedDataUC getSavedDataUC,
    required SettingsSaveUC settingsSaveUC,
  }) : _getSavedDataUC = getSavedDataUC,
       _settingsSaveUC = settingsSaveUC;

  @override
  Future<Either<Failure, SettingsEntity>> getSavedData() {
    return _getSavedDataUC.call(NoParams());
  }

  @override
  Future<Either<Failure, void>> saveSettings(SettingsSaveParams params) {
    return _settingsSaveUC.call(params);
  }
}
