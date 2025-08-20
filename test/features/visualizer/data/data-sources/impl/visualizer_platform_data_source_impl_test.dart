import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late VisualizerPlatformDataSourceImpl platformDataSource;

  setUp(() {
    platformDataSource = VisualizerPlatformDataSourceImpl();
  });

  group("getOutPutAudioStream -", () {
    test("should call the event channel and return a stream of data", () async {
      //arrange
      bool isListenerCalled = false;
      final mockData = [1.0, 2.0, 3.0];
      TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
        platformDataSource.eventChannel,
        MockStreamHandler.inline(
          onListen: (arguments, events) {
            isListenerCalled = true;
            events.success(mockData);
            events.endOfStream();
          },
        ),
      );

      //act
      final stream = await platformDataSource.getOutPutAudioStream();
      final receivedData = await stream.first;

      //assert
      expect(isListenerCalled, true);
      expect(receivedData, mockData);
    });

    test("should return expected data when success", () async {
      //arrange
      final mockData = [1.0, 2.0, 3.0];
      TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
        platformDataSource.eventChannel,
        MockStreamHandler.inline(
          onListen: (arguments, events) {
            events.success(mockData);
            events.endOfStream();
          },
        ),
      );

      //act
      final stream = await platformDataSource.getOutPutAudioStream();

      //assert
      expect(await stream.first, mockData);
    });
  });

  group("getBandsStream -", () {
    test("should return expected result when success ", () async {
      //arrange
      final resData = {
        "Sub-bass": 0.35,
        "Bass": 0.58,
        "Low-mid": 0.42,
        "Mid": 0.30,
        "High-mid": 0.27,
        "Presence": 0.19,
        "Brilliance": 0.14,
        "Loudness": 0.41
      };
      TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockStreamHandler(
        platformDataSource.eventChannel,
        MockStreamHandler.inline(
          onListen: (arguments, events) {
            events.success(resData);
            events.endOfStream();
          },
        ),
      );

      //act
      final result = await platformDataSource.getPerceptualBandsStream();
      final firstElement = await result.first;

      //assert
      expect(firstElement, isA<VisualizerBandsModel>());
      expect(firstElement.bass, resData["Bass"]);
    });
  });
}
