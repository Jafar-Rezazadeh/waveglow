import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

class MockVisualizerRepository extends Mock implements VisualizerRepository {}

class FakeFailure extends Fake implements Failure {}

void main() {
  late MockVisualizerRepository mockVisualizerRepository;
  late GetVisualizerPerceptualBandsStreamUC getVisualizerLiveBandsUC;

  setUp(() {
    mockVisualizerRepository = MockVisualizerRepository();
    getVisualizerLiveBandsUC =
        GetVisualizerPerceptualBandsStreamUC(repository: mockVisualizerRepository);
  });

  test("should call expected method ", () async {
    //arrange
    when(
      () => mockVisualizerRepository.getPerceptualBandsStream(),
    ).thenAnswer((_) async => left(FakeFailure()));

    //act
    await getVisualizerLiveBandsUC.call(NoParams());

    //assert
    verify(() => mockVisualizerRepository.getPerceptualBandsStream()).called(1);
  });
}
