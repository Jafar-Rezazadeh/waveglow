import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/domain/repositories/settings_repository.dart';

class SettingsSaveUC implements UseCase<void, SettingsSaveParams> {
  final SettingsRepository _repository;

  SettingsSaveUC({required SettingsRepository repository}) : _repository = repository;
  @override
  Future<Either<Failure, void>> call(SettingsSaveParams params) {
    return _repository.saveSettings(params);
  }
}

class SettingsSaveParams {
  final ThemeMode themeMode;

  SettingsSaveParams({required this.themeMode});
}
