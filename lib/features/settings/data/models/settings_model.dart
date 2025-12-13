import 'package:flutter/material.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/contracts/model.dart';
import 'package:waveglow/features/settings/domain/entities/settings_entity.dart';

class SettingsModel implements Model<SettingsEntity> {
  final ThemeMode themeMode;
  final LanguageEnum languageEnum;

  SettingsModel({required this.themeMode, required this.languageEnum});

  @override
  SettingsEntity toEntity() {
    return SettingsEntity(themeMode: themeMode, languageEnum: languageEnum);
  }
}
