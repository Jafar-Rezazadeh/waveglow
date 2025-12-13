import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class MockVisualizerPlatformDataSource extends Mock implements VisualizerPlatformDataSource {}

class MockFailureFactory extends Mock implements FailureFactory {}

class FakeFailure extends Fake implements Failure {}

void main() {
  late MockVisualizerPlatformDataSource mockVisualizerPlatformDataSource;
  late MockFailureFactory mockFailureFactory;
  late VisualizerRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockVisualizerPlatformDataSource = MockVisualizerPlatformDataSource();
    mockFailureFactory = MockFailureFactory();
    repositoryImpl = VisualizerRepositoryImpl(
      platformDataSource: mockVisualizerPlatformDataSource,
      failureFactory: mockFailureFactory,
    );
  });

  group("getFrequenciesStream -", () {
    test(
      "should call the $FailureFactory.createFailure and return $Failure when an object is thrown ",
      () async {
        //arrange
        when(() => mockFailureFactory.createFailure(any(), any())).thenAnswer((_) => FakeFailure());
        when(
          () => mockVisualizerPlatformDataSource.getFrequenciesStream(),
        ).thenAnswer((_) async => throw TypeError());

        //act
        final result = await repositoryImpl.getFrequenciesStream();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
      },
    );

    test("should return expected right result when success", () async {
      //arrange
      when(
        () => mockVisualizerPlatformDataSource.getFrequenciesStream(),
      ).thenAnswer((_) async => const Stream.empty());

      //act
      final result = await repositoryImpl.getFrequenciesStream();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<Stream<List<double>>>());
    });
  });

  group("getFrequencyBandsStream -", () {
    test(
      "should call $FailureFactory.createFailure and return kind of Failure when any object is thrown ",
      () async {
        //arrange
        when(() => mockFailureFactory.createFailure(any(), any())).thenAnswer((_) => FakeFailure());
        when(
          () => mockVisualizerPlatformDataSource.getFrequencyBandsStream(),
        ).thenAnswer((_) async => throw TypeError());

        //act
        final result = await repositoryImpl.getFrequencyBandsStream();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return Stream<$VisualizerFrequencyBandsEntity> when success", () async {
      //arrange
      when(
        () => mockVisualizerPlatformDataSource.getFrequencyBandsStream(),
      ).thenAnswer((_) async => const Stream.empty());

      //act
      final result = await repositoryImpl.getFrequencyBandsStream();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<Stream<VisualizerFrequencyBandsEntity>>());
    });
  });
}
