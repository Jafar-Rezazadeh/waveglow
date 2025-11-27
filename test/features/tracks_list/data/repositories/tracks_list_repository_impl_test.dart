import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

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

class _FakeAudioItemModel extends Fake implements AudioItemModel {}

void main() {
  late _MockTracksListDataSource mockDataSource;
  late _MockFailureFactory mockFailureFactory;
  late TracksListRepositoryImpl repositoryImpl;
  final audioEntity = AudioItemEntity(
    path: "path",
    trackName: "trackName",
    albumArt: null,
    durationInSeconds: 4,
    artistsNames: [],
    modifiedDate: "modifiedDate",
    isFavorite: false,
    dirId: "dirId",
  );

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(_FakeTracksListDirectoryModel());
    registerFallbackValue(_FakeAudioItemModel());
    registerFallbackValue(SortTypeEnum.byModifiedDate);
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
      await repositoryImpl.pickDirectory(SortTypeEnum.byModifiedDate);

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
        final result = await repositoryImpl.pickDirectory(SortTypeEnum.byModifiedDate);
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
      final result = await repositoryImpl.pickDirectory(SortTypeEnum.byModifiedDate);
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
      await repositoryImpl.getDirectories(SortTypeEnum.byModifiedDate);

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
        final result = await repositoryImpl.getDirectories(SortTypeEnum.byModifiedDate);
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
      final result = await repositoryImpl.getDirectories(SortTypeEnum.byModifiedDate);
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
      await repositoryImpl.toggleAudioFavorite(audioEntity);

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
        final result = await repositoryImpl.toggleAudioFavorite(audioEntity);
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
      final result = await repositoryImpl.toggleAudioFavorite(audioEntity);
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

  group("getFavoriteSongsStream -", () {
    test("should call expected dataSource method when invoked", () async {
      //arrange
      when(() => mockDataSource.getFavoriteSongsStream()).thenAnswer((_) async => Stream.empty());

      //act
      await repositoryImpl.getFavoriteSongsStream();

      //assert
      verify(() => mockDataSource.getFavoriteSongsStream()).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockDataSource.getFavoriteSongsStream(),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getFavoriteSongsStream();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockDataSource.getFavoriteSongsStream()).thenAnswer((_) async => Stream.empty());

      //act
      final result = await repositoryImpl.getFavoriteSongsStream();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<Stream<List<AudioItemEntity>>>());
    });
  });
}
