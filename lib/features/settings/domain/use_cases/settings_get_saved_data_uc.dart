import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class SettingsGetSavedDataUC implements UseCase<SettingsEntity, NoParams> {
  final SettingsRepository _repository;

  SettingsGetSavedDataUC({required SettingsRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) {
    return _repository.getSavedData();
  }
}
