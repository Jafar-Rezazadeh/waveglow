import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/home/home_exports.dart';
import 'package:waveglow/services/home_audio_bands_service.dart';

class _MockHomeAudioBandsService extends Mock implements HomeAudioBandsService {}

void main() {
  late _MockHomeAudioBandsService mockHomeAudioBandsService;
  late HomeVisualizerStateController controller;

  setUp(() {
    mockHomeAudioBandsService = _MockHomeAudioBandsService();
    controller = HomeVisualizerStateController(audioBandsService: mockHomeAudioBandsService);
  });

  group("startListeningBandsSpectrum -", () {
    test("should call expected method of service when invoked", () async {
      //arrange
      when(() => mockHomeAudioBandsService.start()).thenAnswer((_) async {});

      //act
      await controller.startListeningBandsSpectrum();

      //assert
      verify(() => mockHomeAudioBandsService.start()).called(1);
    });

    test("should listen to bandStream of service and put it to expected variable", () async {
      //arrange
      final bands = HomeVisualizerBandsEntity(
        subBass: 52,
        bass: 54,
        lowMid: 6546,
        mid: 121,
        highMid: 42,
        presence: 5,
        brilliance: 54,
        loudness: 524,
      );
      when(() => mockHomeAudioBandsService.start()).thenAnswer((_) async {});
      when(() => mockHomeAudioBandsService.bandsStream).thenAnswer((_) => Stream.value(bands));

      //act
      await controller.startListeningBandsSpectrum();
      await Future.delayed(Duration(microseconds: 5));

      //assert
      expect(controller.perceptualBands?.lowMid, bands.lowMid);
    });
  });

  group("stopListeningBandsSpectrum -", () {
    test("should call expected method of AudioBandsService when invoked", () async {
      //arrange
      when(() => mockHomeAudioBandsService.stop()).thenAnswer((_) async {});

      //act
      await controller.stopListeningBandsSpectrum();

      //assert
      verify(() => mockHomeAudioBandsService.stop()).called(1);
    });

    test("should set the expected variable values to zero", () async {
      //arrange
      when(() => mockHomeAudioBandsService.stop()).thenAnswer((_) async {});
      controller.setPerceptualBands = VisualizerBandsModel(
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
      await controller.stopListeningBandsSpectrum();

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
  });
}
