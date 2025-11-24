import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';

class _MockTracksListDataSource extends Mock implements TracksListDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeTracksListDirectoryModel extends Fake implements TracksListDirectoryModel {
  @override
  TracksListDirectoryEntity toEntity() {
    return _FakeTracksListDirectoryEntity();
  }
}

class _FakeTracksListDirectoryEntity extends Fake implements TracksListDirectoryEntity {
  @override
  String get id => "id";
  @override
  String get directoryName => "directoryName";
  @override
  String get directoryPath => "directoryPath";
  @override
  List<AudioItemEntity> get audios => [];
}

class _FakeFailure extends Fake implements Failure {}

class _FakeTracksListToggleAudioFavoriteParams extends Fake
    implements TracksListToggleAudioFavoriteParams {}

void main() {
  late _MockTracksListDataSource mockDataSource;
  late _MockFailureFactory mockFailureFactory;
  late TracksListRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(_FakeTracksListDirectoryModel());
    registerFallbackValue(_FakeTracksListToggleAudioFavoriteParams());
    registerFallbackValue(SortType.byModifiedDate);
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
        () => mockDataSource.pickDirectory(any()),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      await repositoryImpl.pickDirectory(SortType.byModifiedDate);

      //assert
      verify(() => mockDataSource.pickDirectory(any())).called(1);
    });

    test(
      "should call $FailureFactory and return kind of failure when any object is thrown by data source ",
      () async {
        //arrange
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        when(() => mockDataSource.pickDirectory(any())).thenAnswer((_) async => throw TypeError());

        //act
        final result = await repositoryImpl.pickDirectory(SortType.byModifiedDate);
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
        () => mockDataSource.pickDirectory(any()),
      ).thenAnswer((_) async => _FakeTracksListDirectoryModel());

      //act
      final result = await repositoryImpl.pickDirectory(SortType.byModifiedDate);
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
      await repositoryImpl.saveDirectory(_FakeTracksListDirectoryEntity());

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
      when(() => mockDataSource.getDirectories(any())).thenAnswer((_) async => []);

      //act
      await repositoryImpl.getDirectories(SortType.byModifiedDate);

      //assert
      verify(() => mockDataSource.getDirectories(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(() => mockDataSource.getDirectories(any())).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getDirectories(SortType.byModifiedDate);
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
        () => mockDataSource.getDirectories(any()),
      ).thenAnswer((_) async => [_FakeTracksListDirectoryModel()]);

      //act
      final result = await repositoryImpl.getDirectories(SortType.byModifiedDate);
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isNotEmpty);
    });
  });

  group("deleteDir -", () {
    test("should call expected dataSource method when invoked", () async {
      //arrange
      when(() => mockDataSource.deleteDir(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.deleteDir("id");

      //assert
      verify(() => mockDataSource.deleteDir(any())).called(1);
    });

    test(
      "should call failureFactory.createFailure and return kind of failure when any object is thrown by data source",
      () async {
        //arrange
        when(() => mockDataSource.deleteDir(any())).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.deleteDir("id");
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockDataSource.deleteDir(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.deleteDir("id");

      //assert
      expect(result.isRight(), true);
    });
  });

  group("isDirectoryExists -", () {
    test("should call expected dataSource method when invoked", () async {
      //arrange
      when(() => mockDataSource.isDirectoryExists(any())).thenAnswer((_) async => true);

      //act
      await repositoryImpl.isDirectoryExists("dirPath");

      //assert
      verify(() => mockDataSource.isDirectoryExists(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown by dataSource",
      () async {
        //arrange
        when(
          () => mockDataSource.isDirectoryExists(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.isDirectoryExists("dirPath");
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockDataSource.isDirectoryExists(any())).thenAnswer((_) async => true);

      //act
      final result = await repositoryImpl.isDirectoryExists("dirPath");
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<bool>());
    });
  });

  group("syncAudios -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(() => mockDataSource.syncAudios()).thenAnswer((_) async {});

      //act
      await repositoryImpl.syncAudios();

      //assert
      verify(() => mockDataSource.syncAudios()).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of Failure when any object is thrown",
      () async {
        //arrange
        when(() => mockDataSource.syncAudios()).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.syncAudios();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockDataSource.syncAudios()).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.syncAudios();

      //assert
      expect(result.isRight(), true);
    });
  });

  group("toggleAudioFavorite -", () {
    test("should call expected dataSource method when invoked", () async {
      //arrange
      when(() => mockDataSource.toggleAudioFavorite(any())).thenAnswer((_) async => true);

      //act
      await repositoryImpl.toggleAudioFavorite(_FakeTracksListToggleAudioFavoriteParams());

      //assert
      verify(() => mockDataSource.toggleAudioFavorite(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockDataSource.toggleAudioFavorite(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.toggleAudioFavorite(
          _FakeTracksListToggleAudioFavoriteParams(),
        );
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return a bool when success", () async {
      //arrange
      when(() => mockDataSource.toggleAudioFavorite(any())).thenAnswer((_) async => true);

      //act
      final result = await repositoryImpl.toggleAudioFavorite(
        _FakeTracksListToggleAudioFavoriteParams(),
      );
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<bool>());
    });
  });

  group("getFavoriteSongs -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(() => mockDataSource.getFavoriteSongs()).thenAnswer((_) async => []);

      //act
      await repositoryImpl.getFavoriteSongs();

      //assert
      verify(() => mockDataSource.getFavoriteSongs()).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(() => mockDataSource.getFavoriteSongs()).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getFavoriteSongs();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockDataSource.getFavoriteSongs()).thenAnswer((_) async => []);

      //act
      final result = await repositoryImpl.getFavoriteSongs();
      final rightValue = result.fold((l) => l, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<List<AudioItemEntity>>());
    });
  });
}
