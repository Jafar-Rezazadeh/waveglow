import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/features/visualizer/data/data-sources/impl/visualizer_platform_data_source_impl.dart';

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
}
