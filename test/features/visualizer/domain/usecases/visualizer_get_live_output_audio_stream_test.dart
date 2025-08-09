import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/features/visualizer/domain/use_cases/visualizer_get_live_output_audio_stream.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class MockVisualizerRepository extends Mock implements VisualizerRepository {}

void main() {
  late MockVisualizerRepository mockVisualizerRepository;
  late VisualizerGetLiveOutPutAudioStreamUC visualizerGetLiveOutPutAudioStreamUC;

  setUp(() {
    mockVisualizerRepository = MockVisualizerRepository();
    visualizerGetLiveOutPutAudioStreamUC = VisualizerGetLiveOutPutAudioStreamUC(
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
