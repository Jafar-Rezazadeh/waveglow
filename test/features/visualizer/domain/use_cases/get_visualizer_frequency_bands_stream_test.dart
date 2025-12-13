import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class MockVisualizerRepository extends Mock implements VisualizerRepository {}

void main() {
  late MockVisualizerRepository mockVisualizerRepository;
  late GetVisualizerFrequenciesStreamUC visualizerGetLiveOutPutAudioStreamUC;

  setUp(() {
    mockVisualizerRepository = MockVisualizerRepository();
    visualizerGetLiveOutPutAudioStreamUC = GetVisualizerFrequenciesStreamUC(
      repository: mockVisualizerRepository,
    );
  });

  test("should call the expected repository method when invoked ", () async {
    //arrange
    when(
      () => mockVisualizerRepository.getFrequenciesStream(),
    ).thenAnswer((invocation) async => right(const Stream<List<double>>.empty()));

    //act
    await visualizerGetLiveOutPutAudioStreamUC.call(NoParams());

    //assert
    verify(() => mockVisualizerRepository.getFrequenciesStream()).called(1);
  });
}
