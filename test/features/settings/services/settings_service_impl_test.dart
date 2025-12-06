import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSettingsGetSavedDataUC extends Mock implements SettingsGetSavedDataUC {}

class _MockSettingsSaveUC extends Mock implements SettingsSaveUC {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockSettingsGetSavedDataUC mockSettingsGetSavedDataUC;
  late _MockSettingsSaveUC mockSettingsSaveUC;
  late SettingsServiceImpl serviceImpl;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(SettingsSaveParams(themeMode: ThemeMode.dark));
  });

  setUp(() {
    mockSettingsGetSavedDataUC = _MockSettingsGetSavedDataUC();
    mockSettingsSaveUC = _MockSettingsSaveUC();
    serviceImpl = SettingsServiceImpl(
      getSavedDataUC: mockSettingsGetSavedDataUC,
      settingsSaveUC: mockSettingsSaveUC,
    );
  });

  group("getSavedData -", () {
    test("should call expected useCase and return expected result ", () async {
      //arrange
      when(
        () => mockSettingsGetSavedDataUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));

      //act
      final result = await serviceImpl.getSavedData();

      //assert
      verify(() => mockSettingsGetSavedDataUC.call(any())).called(1);
      expect(result, isA<Either<Failure, SettingsEntity>>());
    });
  });

  group("saveSettings -", () {
    test("should call expected useCase and return expected result", () async {
      //arrange
      when(() => mockSettingsSaveUC.call(any())).thenAnswer((_) async => right(null));

      //act
      final result = await serviceImpl.saveSettings(SettingsSaveParams(themeMode: ThemeMode.dark));

      //assert
      verify(() => mockSettingsSaveUC.call(any())).called(1);
      expect(result, isA<Either<Failure, void>>());
    });
  });
}
