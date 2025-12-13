import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

abstract class SettingsService {
  Future<Either<Failure, SettingsEntity>> getSavedData();
  Future<Either<Failure, void>> saveSettings(SettingsSaveParams params);
}
