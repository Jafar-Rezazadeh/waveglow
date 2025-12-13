import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/favorite_songs/presentation/state_controllers/favorite_songs_state_controller.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockTracksListService extends Mock implements TracksListService {}

class _MockCustomDialogs extends Mock implements CustomDialogs {}

class _MockMusicPlayerService extends Mock implements MusicPlayerService {}

class _FakeFailure extends Fake implements Failure {}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {
  final String pathT;

  _FakeAudioItemEntity({this.pathT = ""});

  @override
  String get path => pathT;
}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {
  final String idT;
  final List<AudioItemEntity> audiosT;

  _FakeMusicPlayerPlayListEntity({this.idT = "test", this.audiosT = const []});

  @override
  String get id => idT;

  @override
  List<AudioItemEntity> get audios => audiosT;
}

void main() {
  late _MockTracksListService mockTracksListService;
  late _MockCustomDialogs mockCustomDialogs;
  late _MockMusicPlayerService mockMusicPlayerService;
  late FavoriteSongsStateController controller;

  setUpAll(() {
    registerFallbackValue(_FakeFailure());
    registerFallbackValue(_FakeMusicPlayerPlayListEntity());
  });

  setUp(() {
    mockTracksListService = _MockTracksListService();
    mockCustomDialogs = _MockCustomDialogs();
    mockMusicPlayerService = _MockMusicPlayerService();
    controller = FavoriteSongsStateController(
      tracksListService: mockTracksListService,
      customDialogs: mockCustomDialogs,
      musicPlayerService: mockMusicPlayerService,
    );
  });

  group("getFavoriteSongs -", () {
    test("should call expected functionality when invoked", () async {
      //arrange
      when(() => mockTracksListService.getFavoriteSongs()).thenAnswer((_) async => right([]));

      //act
      await controller.getFavoriteSongs();

      //assert
      verify(() => mockTracksListService.getFavoriteSongs()).called(1);
    });

    test("should call $CustomDialogs.showFailure when result is failure", () async {
      //arrange
      when(
        () => mockTracksListService.getFavoriteSongs(),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.getFavoriteSongs();

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should set expected variable when success", () async {
      //arrange
      when(
        () => mockTracksListService.getFavoriteSongs(),
      ).thenAnswer((_) async => right([_FakeAudioItemEntity()]));

      //act
      await controller.getFavoriteSongs();

      //assert
      expect(controller.allFavoriteSongs, isNotEmpty);
    });
  });

  group("playTracks -", () {
    test(
      "should call $MusicPlayerService.openPlayList when currentPlaylist is not the favoriteSongs playList",
      () async {
        //arrange

        when(
          () => mockMusicPlayerService.currentPlaylist,
        ).thenAnswer((_) => _FakeMusicPlayerPlayListEntity(idT: "id1"));
        when(() => mockMusicPlayerService.openPlayList(any())).thenAnswer((_) async {});

        //act
        await controller.playTrack(_FakeAudioItemEntity());

        //assert
        verify(() => mockMusicPlayerService.openPlayList(any())).called(1);
      },
    );

    test(
      "should (NOT) call $MusicPlayerService.openPlayList when currentPlaylist id (Is) favoriteSongs",
      () async {
        //arrange
        when(() => mockMusicPlayerService.currentPlaylist).thenAnswer(
          (_) => _FakeMusicPlayerPlayListEntity(idT: controller.favoriteSongsPlayListId),
        );

        //act
        await controller.playTrack(_FakeAudioItemEntity());

        //assert
        verifyNever(() => mockMusicPlayerService.openPlayList(any()));
      },
    );

    test(
      "should call $MusicPlayerService.playAt when given item found in the favoriteSongs",
      () async {
        //arrange
        final item = _FakeAudioItemEntity(pathT: "test.mp3");
        controller.allFavoriteSongs.addAll([item, _FakeAudioItemEntity(pathT: "jdf-k")]);

        when(() => mockMusicPlayerService.currentPlaylist).thenAnswer(
          (_) =>
              _FakeMusicPlayerPlayListEntity(idT: controller.favoriteSongsPlayListId, audiosT: []),
        );
        when(() => mockMusicPlayerService.playAt(any())).thenAnswer((_) async {});

        //act
        await controller.playTrack(_FakeAudioItemEntity(pathT: item.path));

        //assert
        verify(() => mockMusicPlayerService.playAt(0)).called(1);
      },
    );

    test(
      "should (NOT) call $MusicPlayerService.playAt when given item (Is Not) found in the musicPlayerService currentPlayList",
      () async {
        //arrange
        final item = _FakeAudioItemEntity(pathT: "test.mp3");

        when(() => mockMusicPlayerService.currentPlaylist).thenAnswer(
          (_) => _FakeMusicPlayerPlayListEntity(
            idT: controller.favoriteSongsPlayListId,
            audiosT: [_FakeAudioItemEntity(pathT: "jdf-k")],
          ),
        );

        //act
        await controller.playTrack(_FakeAudioItemEntity(pathT: item.path));

        //assert
        verifyNever(() => mockMusicPlayerService.playAt(any()));
      },
    );
  });

  group("listenFavoriteSongsStream -", () {
    test("should call expected functionality when invoked", () async {
      //arrange
      when(
        () => mockTracksListService.getFavoriteSongsStream(),
      ).thenAnswer((_) async => right(Stream.empty()));

      //act
      await controller.listenFavoriteSongsStream();

      //assert
      verify(() => mockTracksListService.getFavoriteSongsStream()).called(1);
    });

    test("should call $CustomDialogs.showFailure when result is failure", () async {
      //arrange
      when(
        () => mockTracksListService.getFavoriteSongsStream(),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockCustomDialogs.showFailure(any())).thenAnswer((_) async {});

      //act
      await controller.listenFavoriteSongsStream();

      //assert
      verify(() => mockCustomDialogs.showFailure(any())).called(1);
    });

    test("should set expected variable when success", () async {
      //arrange
      when(() => mockTracksListService.getFavoriteSongsStream()).thenAnswer(
        (_) async => right(
          Stream.fromIterable([
            [_FakeAudioItemEntity()],
          ]),
        ),
      );

      //act
      await controller.listenFavoriteSongsStream();
      await Future.delayed(Duration(milliseconds: 5));

      //assert
      expect(controller.allFavoriteSongs, isNotEmpty);
    });
  });
}
