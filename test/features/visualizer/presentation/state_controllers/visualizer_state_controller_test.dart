import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';
import 'package:waveglow/core/services/visualizer_service.dart';

class _MockVisualizerService extends Mock implements VisualizerService {}

class _MockStreamSubscription extends Mock
    implements StreamSubscription<VisualizerFrequencyBandsEntity> {}

void main() {
  final bands = VisualizerFrequencyBandsEntity(
    subBass: 52,
    bass: 54,
    lowMid: 6546,
    mid: 121,
    highMid: 42,
    presence: 5,
    brilliance: 54,
    loudness: 524,
  );
  late _MockStreamSubscription mockStreamSubscription;
  late _MockVisualizerService mockVisualizerService;
  late VisualizerStateController controller;

  setUp(() {
    mockStreamSubscription = _MockStreamSubscription();
    mockVisualizerService = _MockVisualizerService();
    controller = VisualizerStateController(
      audioBandsService: mockVisualizerService,
      mockStreamSub: mockStreamSubscription,
    );
  });

  group("startListeningFrequencyBands -", () {
    test("should call expected method of service when invoked", () async {
      //arrange
      when(() => mockVisualizerService.start()).thenAnswer((_) async {});
      when(() => mockVisualizerService.bandsStream).thenAnswer((_) => Stream.value(bands));

      //act
      await controller.startListeningFrequencyBands();

      //assert
      verify(() => mockVisualizerService.start()).called(1);
    });

    test("should listen to bandStream of service and put it to expected variable", () async {
      //arrange

      when(() => mockVisualizerService.start()).thenAnswer((_) async {});
      when(() => mockVisualizerService.bandsStream).thenAnswer((_) => Stream.value(bands));

      //act
      await controller.startListeningFrequencyBands();
      await Future.delayed(Duration(microseconds: 5));

      //assert
      expect(controller.perceptualBands?.lowMid, bands.lowMid);
    });

    test("should add the subscription to bandsService to expected variable", () async {
      //arrange
      final bands = VisualizerFrequencyBandsEntity(
        subBass: 52,
        bass: 54,
        lowMid: 6546,
        mid: 121,
        highMid: 42,
        presence: 5,
        brilliance: 54,
        loudness: 524,
      );
      when(() => mockVisualizerService.start()).thenAnswer((_) async {});
      when(() => mockVisualizerService.bandsStream).thenAnswer((_) => Stream.value(bands));

      //act
      await controller.startListeningFrequencyBands();
      await Future.delayed(Duration(microseconds: 5));

      //assert
      expect(controller.bandsStreamSub, isNotNull);
    });
  });

  group("stopListeningFrequencyBands -", () {
    test("should call expected method of AudioBandsService when invoked", () async {
      //arrange
      when(() => mockVisualizerService.stop()).thenAnswer((_) async {});
      when(() => mockStreamSubscription.cancel()).thenAnswer((_) async {});

      //act
      await controller.stopListeningFrequencyBands();

      //assert
      verify(() => mockVisualizerService.stop()).called(1);
    });

    test("should set the expected variable values to zero", () async {
      //arrange
      when(() => mockVisualizerService.stop()).thenAnswer((_) async {});
      when(() => mockStreamSubscription.cancel()).thenAnswer((_) async {});
      controller.setPerceptualBands = VisualizerFrequencyBandsModel(
        subBass: 554,
        bass: 53465,
        lowMid: 2354,
        mid: 534,
        highMid: 534,
        presence: 5674,
        brilliance: 635,
        loudness: 54,
      );

      //act
      await controller.stopListeningFrequencyBands();

      //assert
      expect(controller.perceptualBands?.subBass, 0);
      expect(controller.perceptualBands?.bass, 0);
      expect(controller.perceptualBands?.lowMid, 0);
      expect(controller.perceptualBands?.mid, 0);
      expect(controller.perceptualBands?.highMid, 0);
      expect(controller.perceptualBands?.presence, 0);
      expect(controller.perceptualBands?.brilliance, 0);
      expect(controller.perceptualBands?.loudness, 0);
    });

    test("should call cancel method of subs", () async {
      //arrange
      when(() => mockVisualizerService.stop()).thenAnswer((_) async {});
      when(() => mockStreamSubscription.cancel()).thenAnswer((_) async {});

      //act
      await controller.stopListeningFrequencyBands();

      //assert
      verify(() => mockStreamSubscription.cancel()).called(1);
    });
  });
}
