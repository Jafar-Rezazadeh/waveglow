import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/home/home_exports.dart';

class MockVisualizerRepository extends Mock implements HomeVisualizerRepository {}

void main() {
  late MockVisualizerRepository mockVisualizerRepository;
  late GetHomeVisualizerLiveOutPutAudioStreamUC visualizerGetLiveOutPutAudioStreamUC;

  setUp(() {
    mockVisualizerRepository = MockVisualizerRepository();
    visualizerGetLiveOutPutAudioStreamUC = GetHomeVisualizerLiveOutPutAudioStreamUC(
      repository: mockVisualizerRepository,
    );
  });

  test("should call the expected repository method when invoked ", () async {
    //arrange
    when(
      () => mockVisualizerRepository.getOutPutAudioStream(),
    ).thenAnswer((invocation) async => right(const Stream<List<double>>.empty()));

    //act
    await visualizerGetLiveOutPutAudioStreamUC.call(NoParams());

    //assert
    verify(() => mockVisualizerRepository.getOutPutAudioStream()).called(1);
  });
}
