import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/settings/settings_export.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _FakeSettingsEntity extends Fake implements SettingsEntity {}

void main() {
  late _MockSettingsRepository mockSettingsRepository;
  late SettingsGetSavedDataUC getSavedDataUC;

  setUp(() {
    mockSettingsRepository = _MockSettingsRepository();
    getSavedDataUC = SettingsGetSavedDataUC(repository: mockSettingsRepository);
  });

  test("should call expected functionality when invoked", () async {
    //arrange
    when(
      () => mockSettingsRepository.getSavedData(),
    ).thenAnswer((_) async => right(_FakeSettingsEntity()));

    //act
    await getSavedDataUC.call(NoParams());

    //assert
    verify(() => mockSettingsRepository.getSavedData()).called(1);
  });

  test("should return expected result", () async {
    //arrange
    when(
      () => mockSettingsRepository.getSavedData(),
    ).thenAnswer((_) async => right(_FakeSettingsEntity()));

    //act
    final result = await getSavedDataUC.call(NoParams());

    //assert
    expect(result, isA<Either<Failure, SettingsEntity>>());
  });
}
