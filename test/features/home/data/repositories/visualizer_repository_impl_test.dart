import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

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

  group("getOutPutAudioStream -", () {
    test(
        "should call the $FailureFactory.createFailure and return $Failure when an object is thrown ",
        () async {
      //arrange
      when(
        () => mockFailureFactory.createFailure(any(), any()),
      ).thenAnswer((_) => FakeFailure());
      when(
        () => mockVisualizerPlatformDataSource.getOutPutAudioStream(),
      ).thenAnswer((_) async => throw TypeError());

      //act
      final result = await repositoryImpl.getOutPutAudioStream();
      final leftValue = result.fold((l) => l, (r) => null);

      //assert
      expect(result.isLeft(), true);
      expect(leftValue, isA<Failure>());
      verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
    });

    test("should return expected right result when success", () async {
      //arrange
      when(
        () => mockVisualizerPlatformDataSource.getOutPutAudioStream(),
      ).thenAnswer((_) async => const Stream.empty());

      //act
      final result = await repositoryImpl.getOutPutAudioStream();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<Stream<List<double>>>());
    });
  });

  group("getBandsStream -", () {
    test(
        "should call $FailureFactory.createFailure and return kind of Failure when any object is thrown ",
        () async {
      //arrange
      when(
        () => mockFailureFactory.createFailure(any(), any()),
      ).thenAnswer((_) => FakeFailure());
      when(
        () => mockVisualizerPlatformDataSource.getPerceptualBandsStream(),
      ).thenAnswer((_) async => throw TypeError());

      //act
      final result = await repositoryImpl.getPerceptualBandsStream();
      final leftValue = result.fold((l) => l, (r) => null);

      //assert
      verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
      expect(result.isLeft(), true);
      expect(leftValue, isA<Failure>());
    });

    test("should return Stream<$VisualizerBandsEntity> when success", () async {
      //arrange
      when(
        () => mockVisualizerPlatformDataSource.getPerceptualBandsStream(),
      ).thenAnswer((_) async => const Stream.empty());

      //act
      final result = await repositoryImpl.getPerceptualBandsStream();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<Stream<VisualizerBandsEntity>>());
    });
  });
}
