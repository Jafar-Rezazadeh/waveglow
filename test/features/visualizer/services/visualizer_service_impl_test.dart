import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class _MockGetVisualizerFrequencyBandsStreamUC extends Mock
    implements GetVisualizerFrequencyBandsStreamUC {}

class _FakeFailure extends Fake implements Failure {
  @override
  String get message => "message";
}

class _FakeVisualizerFrequencyBandsEntity extends Fake implements VisualizerFrequencyBandsEntity {}

void main() {
  late VisualizerServiceImpl serviceImpl;
  late _MockGetVisualizerFrequencyBandsStreamUC mockGetBandsStreamUC;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetBandsStreamUC = _MockGetVisualizerFrequencyBandsStreamUC();
    serviceImpl = VisualizerServiceImpl(getBandsStreamUC: mockGetBandsStreamUC);
  });

  group("start -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockGetBandsStreamUC.call(any())).thenAnswer((_) async => left(_FakeFailure()));

      //act
      await serviceImpl.start();

      //assert
      verify(() => mockGetBandsStreamUC.call(any())).called(1);
    });

    test("should add events to controller when result is success", () async {
      //arrange
      when(
        () => mockGetBandsStreamUC.call(any()),
      ).thenAnswer((_) async => right(Stream.value(_FakeVisualizerFrequencyBandsEntity())));

      //act
      await serviceImpl.start();

      //assert
      expect(await serviceImpl.bandsStream.first, isA<VisualizerFrequencyBandsEntity>());
    });
  });
}
