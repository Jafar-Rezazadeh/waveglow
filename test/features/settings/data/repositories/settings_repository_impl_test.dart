import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSettingsDataSource extends Mock implements SettingsDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeSettingsSaveParams extends Fake implements SettingsSaveParams {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockSettingsDataSource mockSettingsDataSource;
  late _MockFailureFactory mockFailureFactory;
  late SettingsRepositoryImpl repositoryImpl;
  final fakeSettingsModel = SettingsModel(themeMode: ThemeMode.light);

  setUpAll(() {
    registerFallbackValue(_FakeSettingsSaveParams());
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockFailureFactory = _MockFailureFactory();
    mockSettingsDataSource = _MockSettingsDataSource();
    repositoryImpl = SettingsRepositoryImpl(
      settingsDataSource: mockSettingsDataSource,
      failureFactory: mockFailureFactory,
    );
  });

  group("saveSettings -", () {
    test("should call expected method of the repository ", () async {
      //arrange
      when(() => mockSettingsDataSource.saveSettings(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.saveSettings(_FakeSettingsSaveParams());

      //assert
      verify(() => mockSettingsDataSource.saveSettings(any())).called(1);
    });

    test(
      "should call FailureFactory.createFailure and return kind of Failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockSettingsDataSource.saveSettings(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.saveSettings(_FakeSettingsSaveParams());
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockSettingsDataSource.saveSettings(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.saveSettings(_FakeSettingsSaveParams());

      //assert
      expect(result.isRight(), true);
    });
  });

  group("getSavedData -", () {
    test("should call expected functionality ", () async {
      //arrange
      when(() => mockSettingsDataSource.getSavedData()).thenAnswer((_) async => fakeSettingsModel);

      //act
      await repositoryImpl.getSavedData();

      //assert
      verify(() => mockSettingsDataSource.getSavedData()).called(1);
    });

    test(
      "should call failureFactory,createFailure and return kind of failure when any object is thrown ",
      () async {
        //arrange
        when(
          () => mockSettingsDataSource.getSavedData(),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getSavedData();
        final leftFailure = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftFailure, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockSettingsDataSource.getSavedData()).thenAnswer((_) async => fakeSettingsModel);

      //act
      final result = await repositoryImpl.getSavedData();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<SettingsEntity>());
    });
  });
}
