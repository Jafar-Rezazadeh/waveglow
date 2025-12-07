import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/services/settings_service.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSettingsService extends Mock implements SettingsService {}

class _MockCustomDialogs extends Mock implements CustomDialogs {}

class _FakeFailure extends Fake implements Failure {}

class _FakeSettingsSaveParams extends Fake implements SettingsSaveParams {}

class _FakeSettingsEntity extends Fake implements SettingsEntity {}

void main() {
  late _MockSettingsService mockSettingsService;
  late _MockCustomDialogs mockCustomDialogs;
  late SettingsStateController controller;

  setUpAll(() {
    registerFallbackValue(_FakeFailure());
    registerFallbackValue(_FakeSettingsSaveParams());
  });

  setUp(() {
    mockSettingsService = _MockSettingsService();
    mockCustomDialogs = _MockCustomDialogs();
    controller = SettingsStateController(
      settingsService: mockSettingsService,
      customDialogs: mockCustomDialogs,
    );
  });

  group("getSavedData -", () {
    test("should call expected functionality  ", () async {
      //arrange
      when(
        () => mockSettingsService.getSavedData(),
      ).thenAnswer((_) async => right(_FakeSettingsEntity()));

      //act
      await controller.getSavedData();

      //assert
      verify(() => mockSettingsService.getSavedData()).called(1);
    });

    test("should call expected functionality when result is failure", () async {
      //arrange
      when(() => mockSettingsService.getSavedData()).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.getSavedData();

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should set settings variable when success", () async {
      //arrange
      final settings = SettingsEntity(
        themeMode: ThemeMode.light,
        languageEnum: LanguageEnum.english,
      );
      when(() => mockSettingsService.getSavedData()).thenAnswer((_) async => right(settings));

      //act
      await controller.getSavedData();

      //assert
      expect(controller.settings, settings);
    });
  });

  group("changeTheme -", () {
    test("should call expected functionality when result is failure", () async {
      //arrange
      when(
        () => mockSettingsService.saveSettings(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.changeTheme(ThemeMode.light);

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should call expected functionality when success", () async {
      //arrange
      when(() => mockSettingsService.saveSettings(any())).thenAnswer((_) async => right(null));
      when(() => mockSettingsService.getSavedData()).thenAnswer(
        (_) async =>
            right(SettingsEntity(themeMode: ThemeMode.light, languageEnum: LanguageEnum.english)),
      );

      //act
      await controller.changeTheme(ThemeMode.light);

      //assert
      verify(() => mockSettingsService.getSavedData()).called(1);
    });
  });

  group("changeLocale -", () {
    test("should call expected useCase when give value isNot Null", () async {
      //arrange
      when(
        () => mockSettingsService.saveSettings(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.changeLocale(LanguageEnum.english);

      //assert
      verify(() => mockSettingsService.saveSettings(any())).called(1);
    });

    test("should NOT call expected functionality when give value Is Null", () async {
      //arrange
      when(() => mockSettingsService.saveSettings(any())).thenAnswer((_) async => right(null));

      //act
      await controller.changeLocale(null);

      //assert
      verifyNever(() => mockSettingsService.saveSettings(any()));
    });

    test("should call expected functionality when result is a failure", () async {
      //arrange
      when(
        () => mockSettingsService.saveSettings(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.changeLocale(LanguageEnum.english);

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should call expected functionality when success", () async {
      //arrange
      when(() => mockSettingsService.saveSettings(any())).thenAnswer((_) async => right(null));
      when(
        () => mockSettingsService.getSavedData(),
      ).thenAnswer((_) async => right(_FakeSettingsEntity()));

      //act
      await controller.changeLocale(LanguageEnum.english);

      //assert
      verify(() => mockSettingsService.getSavedData()).called(1);
    });
  });
}
