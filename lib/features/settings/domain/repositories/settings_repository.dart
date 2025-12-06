import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

abstract class SettingsRepository {
  Future<Either<Failure, void>> saveSettings(SettingsSaveParams params);
  Future<Either<Failure, SettingsEntity>> getSavedData();
}
