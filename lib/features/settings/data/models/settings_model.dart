import 'package:flutter/material.dart';
import 'package:waveglow/core/contracts/model.dart';
import 'package:waveglow/features/settings/domain/entities/settings_entity.dart';

class SettingsModel implements Model<SettingsEntity> {
  final ThemeMode themeMode;

  SettingsModel({required this.themeMode});

  @override
  SettingsEntity toEntity() {
    return SettingsEntity(themeMode: themeMode);
  }
}
