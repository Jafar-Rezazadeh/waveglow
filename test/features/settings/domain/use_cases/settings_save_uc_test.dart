import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _FakeSettingsSaveParams extends Fake implements SettingsSaveParams {}

void main() {
  late _MockSettingsRepository mockSettingsRepository;
  late SettingsSaveUC saveUC;

  setUpAll(() {
    registerFallbackValue(_FakeSettingsSaveParams());
  });

  setUp(() {
    mockSettingsRepository = _MockSettingsRepository();
    saveUC = SettingsSaveUC(repository: mockSettingsRepository);
  });

  test("should call expected method of repository when invoke", () async {
    //arrange
    when(() => mockSettingsRepository.saveSettings(any())).thenAnswer((_) async => right(null));

    //act
    await saveUC.call(_FakeSettingsSaveParams());

    //assert
    verify(() => mockSettingsRepository.saveSettings(any())).called(1);
  });

  test("should return expected result ", () async {
    //arrange
    when(() => mockSettingsRepository.saveSettings(any())).thenAnswer((_) async => right(null));

    //act
    final result = await saveUC.call(_FakeSettingsSaveParams());

    //assert
    expect(result, isA<Either<Failure, void>>());
  });
}
