import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final FailureFactory _failureFactory;
  final SettingsDataSource _settingsDataSource;

  SettingsRepositoryImpl({
    required SettingsDataSource settingsDataSource,
    required FailureFactory failureFactory,
  }) : _settingsDataSource = settingsDataSource,
       _failureFactory = failureFactory;

  @override
  Future<Either<Failure, void>> saveSettings(SettingsSaveParams params) async {
    try {
      final result = await _settingsDataSource.saveSettings(params);
      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> getSavedData() async {
    try {
      final model = await _settingsDataSource.getSavedData();
      return right(model.toEntity());
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }
}
