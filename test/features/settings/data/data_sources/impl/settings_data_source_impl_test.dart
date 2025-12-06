import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final saveParams = SettingsSaveParams(themeMode: ThemeMode.dark);
    test("should call expected functionally when called", () async {
      //arrange
      when(() => mockSharedPreferences.setInt(any(), any())).thenAnswer((_) async => true);

      //act
      await dataSourceImpl.saveSettings(saveParams);

      //assert
      verify(
        () => mockSharedPreferences.setInt(dataSourceImpl.themeKey, saveParams.themeMode.index),
      ).called(1);
    });
  });

  group("getSavedData -", () {
    test("should call expected functionality and return expected result when success", () async {
      //arrange
      when(() => mockSharedPreferences.getInt(any())).thenAnswer((_) => ThemeMode.light.index);

      //act
      final result = await dataSourceImpl.getSavedData();

      //assert
      verify(() => mockSharedPreferences.getInt(dataSourceImpl.themeKey)).called(1);
      expect(result, isA<SettingsModel>());
      expect(result.themeMode, ThemeMode.light);
    });
  });
}
