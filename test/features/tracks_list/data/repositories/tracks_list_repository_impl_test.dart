import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class _MockTracksListDataSource extends Mock implements TracksListDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeTracksListDirectoryModel extends Fake implements TracksListDirectoryModel {}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {}

class _FakeFailure extends Fake implements Failure {}

void main() {
  late _MockTracksListDataSource mockDataSource;
  late _MockFailureFactory mockFailureFactory;
  late TracksListRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(_FakeTracksListDirectoryModel());
  });

  setUp(() {
    mockDataSource = _MockTracksListDataSource();
    mockFailureFactory = _MockFailureFactory();
    repositoryImpl = TracksListRepositoryImpl(
      dataSource: mockDataSource,
      failureFactory: mockFailureFactory,
    );
  });

  group("pickDirectory -", () {
    test("should call expected dataSource ", () async {
      //arrange
      when(
        () => mockDataSource.pickDirectory(),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      await repositoryImpl.pickDirectory();

      //assert
      verify(() => mockDataSource.pickDirectory()).called(1);
    });

    test(
      "should call $FailureFactory and return kind of failure when any object is thrown by data source ",
      () async {
        //arrange
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        when(() => mockDataSource.pickDirectory()).thenAnswer((_) async => throw TypeError());

        //act
        final result = await repositoryImpl.pickDirectory();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(
        () => mockDataSource.pickDirectory(),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      final result = await repositoryImpl.pickDirectory();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<TracksListDirectoryEntity>());
    });
  });

  group("saveDirectory -", () {
    test("should invoke the expected method of the data source ", () async {
      //arrange
      when(() => mockDataSource.saveDirectory(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.saveDirectory(_FakeTracksListDirectoryModel());

      //assert
      verify(() => mockDataSource.saveDirectory(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown by dataSource",
      () async {
        //arrange
        when(() => mockDataSource.saveDirectory(any())).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.saveDirectory(_FakeTracksListDirectoryEntity());
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return void the success", () async {
      //arrange
      when(() => mockDataSource.saveDirectory(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.saveDirectory(_FakeTracksListDirectoryEntity());

      //assert
      expect(result.isRight(), true);
    });
  });

  group("getDirectories -", () {
    test("should call expected data source method when invoked", () async {
      //arrange
      when(() => mockDataSource.getDirectories()).thenAnswer((_) async => []);

      //act
      await repositoryImpl.getDirectories();

      //assert
      verify(() => mockDataSource.getDirectories()).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(() => mockDataSource.getDirectories()).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getDirectories();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return right result when success", () async {
      //arrange
      when(
        () => mockDataSource.getDirectories(),
      ).thenAnswer((_) async => [_FakeTracksListDirectoryEntity()]);

      //act
      final result = await repositoryImpl.getDirectories();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isNotEmpty);
    });
  });
}
