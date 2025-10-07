import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListDataSource extends Mock implements TracksListDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeTracksListDirectoryModel extends Fake implements TracksListDirectoryModel {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockTracksListDataSource mockTracksListDataSource;
  late _MockFailureFactory mockFailureFactory;
  late TracksListRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    mockTracksListDataSource = _MockTracksListDataSource();
    mockFailureFactory = _MockFailureFactory();
    repositoryImpl = TracksListRepositoryImpl(
      dataSource: mockTracksListDataSource,
      failureFactory: mockFailureFactory,
    );
  });

  group("pickDirectory -", () {
    test("should call expected dataSource ", () async {
      //arrange
      when(
        () => mockTracksListDataSource.pickDirectory(),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      await repositoryImpl.pickDirectory();

      //assert
      verify(() => mockTracksListDataSource.pickDirectory()).called(1);
    });

    test(
        "should call $FailureFactory and return kind of failure when any object is thrown by data source ",
        () async {
      //arrange
      when(
        () => mockFailureFactory.createFailure(any(), any()),
      ).thenAnswer((_) => _FakeFailure());

      when(
        () => mockTracksListDataSource.pickDirectory(),
      ).thenAnswer((_) async => throw TypeError());

      //act
      final result = await repositoryImpl.pickDirectory();
      final leftValue = result.fold((l) => l, (r) => null);

      //assert
      verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
      expect(result.isLeft(), true);
      expect(leftValue, isA<Failure>());
    });

    test("should return expected result when success", () async {
      //arrange
      when(
        () => mockTracksListDataSource.pickDirectory(),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      final result = await repositoryImpl.pickDirectory();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<TracksListDirectoryEntity>());
    });
  });
}
