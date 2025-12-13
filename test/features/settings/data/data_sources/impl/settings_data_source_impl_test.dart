import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late _MockSharedPreferences mockSharedPreferences;
  late SettingsDataSourceImpl dataSourceImpl;

  setUp(() {
    mockSharedPreferences = _MockSharedPreferences();
    dataSourceImpl = SettingsDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group("saveSettings -", () {
    final saveParams = SettingsSaveParams(
      themeMode: ThemeMode.dark,
      language: LanguageEnum.english,
    );
    test("should call expected functionally when called given params are not null", () async {
      //arrange
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);

      //act
      await dataSourceImpl.saveSettings(saveParams);

      //assert
      verify(
        () => mockSharedPreferences.setInt(dataSourceImpl.themeKey, saveParams.themeMode!.index),
      ).called(1);
      verify(
        () => mockSharedPreferences.setInt(dataSourceImpl.languageKey, saveParams.language!.index),
      ).called(1);
    });

    test("should NOT call expected functionally when given params is null", () async {
      //arrange
      final params = SettingsSaveParams(themeMode: null, language: null);
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);

      //act
      await dataSourceImpl.saveSettings(params);

      //assert
      verifyNever(() => mockSharedPreferences.setInt(any(), any()));
    });
  });

  group("getSavedData -", () {
    test("should call expected functionality and return expected result when success", () async {
      //arrange
      when(
        () => mockSharedPreferences.getInt(dataSourceImpl.themeKey),
      ).thenAnswer((_) => ThemeMode.light.index);
      when(
        () => mockSharedPreferences.getInt(dataSourceImpl.languageKey),
      ).thenAnswer((_) => LanguageEnum.persian.index);

      //act
      final result = await dataSourceImpl.getSavedData();

      //assert
      verify(() => mockSharedPreferences.getInt(dataSourceImpl.themeKey)).called(1);
      verify(() => mockSharedPreferences.getInt(dataSourceImpl.languageKey)).called(1);
      expect(result, isA<SettingsModel>());
      expect(result.themeMode, ThemeMode.light);
      expect(result.languageEnum, LanguageEnum.persian);
    });
  });
}
