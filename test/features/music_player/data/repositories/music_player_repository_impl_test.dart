import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerDataSource extends Mock implements MusicPlayerDataSource {}

class _MockFailureFactory extends Mock implements FailureFactory {}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {
  @override
  String get id => "id";

  @override
  List<AudioItemEntity> get audios => [];
}

class _FakeFailure extends Fake implements Failure {}

class _FakeMusicPlayerPlayListModel extends Fake implements MusicPlayerPlayListModel {
  @override
  MusicPlayerPlayListEntity toEntity() {
    return _FakeMusicPlayerPlayListEntity();
  }
}

class _FakeMusicPlayerSaveControlsParam extends Fake implements MusicPlayerSaveControlsParam {}

class _FakeMusicPlayerControlsEntity extends Fake implements MusicPlayerControlsEntity {}

void main() {
  late _MockMusicPlayerDataSource mockMusicPlayerDataSource;
  late _MockFailureFactory mockFailureFactory;
  late MusicPlayerRepositoryImpl repositoryImpl;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerPlayListModel());
    registerFallbackValue(StackTrace.empty);
    registerFallbackValue(_FakeMusicPlayerSaveControlsParam());
  });

  setUp(() {
    mockMusicPlayerDataSource = _MockMusicPlayerDataSource();
    mockFailureFactory = _MockFailureFactory();
    repositoryImpl = MusicPlayerRepositoryImpl(
      failureFactory: mockFailureFactory,
      musicPlayerDataSource: mockMusicPlayerDataSource,
    );
  });

  group("saveCurrentPlayList -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());

      //assert
      verify(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockMusicPlayerDataSource.saveCurrentPlayList(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveCurrentPlayList(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListEntity());

      //assert
      expect(result.isRight(), true);
    });
  });

  group("getLastSavedPlaylist -", () {
    test("should return expected result when success ", () async {
      //arrange
      when(
        () => mockMusicPlayerDataSource.getLastSavedPlaylist(),
      ).thenAnswer((_) async => _FakeMusicPlayerPlayListModel());

      //act
      final result = await repositoryImpl.getLastSavedPlaylist();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<MusicPlayerPlayListEntity>());
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockMusicPlayerDataSource.getLastSavedPlaylist(),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getLastSavedPlaylist();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );
  });

  group("saveMediaControls -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveMediaControls(any())).thenAnswer((_) async {});

      //act
      await repositoryImpl.saveMediaControls(_FakeMusicPlayerSaveControlsParam());

      //assert
      verify(() => mockMusicPlayerDataSource.saveMediaControls(any())).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of $Failure when any object is thrown",
      () async {
        //arrange
        when(
          () => mockMusicPlayerDataSource.saveMediaControls(any()),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.saveMediaControls(_FakeMusicPlayerSaveControlsParam());
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return void when success", () async {
      //arrange
      when(() => mockMusicPlayerDataSource.saveMediaControls(any())).thenAnswer((_) async {});

      //act
      final result = await repositoryImpl.saveMediaControls(_FakeMusicPlayerSaveControlsParam());
      final rightValue = result.fold((l) => l, (r) => null);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, null);
    });
  });

  group("getControls -", () {
    test("should call expected method of dataSource when invoked", () async {
      //arrange
      when(
        () => mockMusicPlayerDataSource.getMediaControls(),
      ).thenAnswer((_) async => _FakeMusicPlayerControlsEntity());

      //act
      await repositoryImpl.getControls();

      //assert
      verify(() => mockMusicPlayerDataSource.getMediaControls()).called(1);
    });

    test(
      "should call $FailureFactory.createFailure and return kind of failure when any object is throw ",
      () async {
        //arrange
        when(
          () => mockMusicPlayerDataSource.getMediaControls(),
        ).thenAnswer((_) async => throw TypeError());
        when(
          () => mockFailureFactory.createFailure(any(), any()),
        ).thenAnswer((_) => _FakeFailure());

        //act
        final result = await repositoryImpl.getControls();
        final leftValue = result.fold((l) => l, (r) => null);

        //assert
        verify(() => mockFailureFactory.createFailure(any(), any())).called(1);
        expect(result.isLeft(), true);
        expect(leftValue, isA<Failure>());
      },
    );

    test("should return expected result when success ", () async {
      //arrange
      when(
        () => mockMusicPlayerDataSource.getMediaControls(),
      ).thenAnswer((_) async => _FakeMusicPlayerControlsEntity());

      //act
      final result = await repositoryImpl.getControls();
      final rightValue = result.fold((l) => null, (r) => r);

      //assert
      expect(result.isRight(), true);
      expect(rightValue, isA<MusicPlayerControlsEntity>());
    });
  });
}
