import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockMusicPlayerGetLastSavedPlaylistUC extends Mock
    implements MusicPlayerGetLastSavedPlaylistUC {}

class _MockMusicPlayerSaveCurrentPlayListUC extends Mock
    implements MusicPlayerSaveCurrentPlayListUC {}

class _MockPlayer extends Mock implements Player {}

class _MockLogger extends Mock implements Logger {}

class _MockMusicPlayerSaveControlsUC extends Mock implements MusicPlayerSaveControlsUC {}

class _MockMusicPlayerGetSavedControlsUC extends Mock implements MusicPlayerGetSavedControlsUC {}

class _FakeMusicPlayerPlayListEntity extends Fake implements MusicPlayerPlayListEntity {
  final List<AudioItemEntity> audiosT;

  _FakeMusicPlayerPlayListEntity({this.audiosT = const []});

  @override
  List<AudioItemEntity> get audios => audiosT;
}

class _FakeAudioItemEntity extends Fake implements AudioItemEntity {
  @override
  String get path => "path";
}

class _FakePlaylist extends Fake implements Playlist {}

class _FakeFailure extends Fake implements Failure {
  @override
  String get message => "";

  @override
  StackTrace get stackTrace => StackTrace.empty;
}

class _FakeMusicPlayerSaveControlsParam extends Fake implements MusicPlayerSaveControlsParam {}

void main() {
  late _MockMusicPlayerGetLastSavedPlaylistUC mockGetLastSavedPlaylistUC;
  late _MockMusicPlayerSaveCurrentPlayListUC mockSaveCurrentPlayListUC;
  late _MockMusicPlayerSaveControlsUC mockMusicPlayerSaveControlsUC;
  late _MockMusicPlayerGetSavedControlsUC mockMusicPlayerGetControlsUC;
  late _MockPlayer mockPlayer;
  late _MockLogger mockLogger;
  late MusicPlayerServiceImpl serviceImpl;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakePlaylist());
    registerFallbackValue(_FakeMusicPlayerPlayListEntity());
    registerFallbackValue(_FakeMusicPlayerSaveControlsParam());
    registerFallbackValue(PlaylistMode.none);
  });

  setUp(() {
    mockGetLastSavedPlaylistUC = _MockMusicPlayerGetLastSavedPlaylistUC();
    mockSaveCurrentPlayListUC = _MockMusicPlayerSaveCurrentPlayListUC();
    mockPlayer = _MockPlayer();
    mockLogger = _MockLogger();
    mockMusicPlayerSaveControlsUC = _MockMusicPlayerSaveControlsUC();
    mockMusicPlayerGetControlsUC = _MockMusicPlayerGetSavedControlsUC();
    serviceImpl = MusicPlayerServiceImpl(
      player: mockPlayer,
      saveCurrentPlayListUC: mockSaveCurrentPlayListUC,
      getLastSavedPlaylistUC: mockGetLastSavedPlaylistUC,
      logger: mockLogger,
      saveControlsUC: mockMusicPlayerSaveControlsUC,
      getSavedControlsUC: mockMusicPlayerGetControlsUC,
    );
  });

  group("getLastSavedPlaylist -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(
        () => mockGetLastSavedPlaylistUC.call(any()),
      ).thenAnswer((_) async => right(_FakeMusicPlayerPlayListEntity()));

      //act
      await serviceImpl.getLastSavedPlaylist();

      //assert
      verify(() => mockGetLastSavedPlaylistUC.call(any())).called(1);
    });

    test("should set currentPlayList and current dir when success", () async {
      //arrange
      when(
        () => mockGetLastSavedPlaylistUC.call(any()),
      ).thenAnswer((_) async => right(_FakeMusicPlayerPlayListEntity()));

      //act
      await serviceImpl.getLastSavedPlaylist();

      //assert
      expect(serviceImpl.currentPlaylist, isNotNull);
    });
  });

  group("savePlaylist -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockSaveCurrentPlayListUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await serviceImpl.savePlaylist(_FakeMusicPlayerPlayListEntity());

      //assert
      verify(() => mockSaveCurrentPlayListUC.call(any())).called(1);
    });

    test("should call $Logger.e when useCase result is a failure ", () async {
      //arrange
      when(
        () => mockSaveCurrentPlayListUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockLogger.e(any())).thenAnswer((_) async {});

      //act
      await serviceImpl.savePlaylist(_FakeMusicPlayerPlayListEntity());

      //assert
      verify(() => mockLogger.e(any())).called(1);
    });
  });

  group("openPlayList -", () {
    test("should call expected useCase when invoked", () async {
      //arrange
      when(() => mockPlayer.open(any(), play: any(named: "play"))).thenAnswer((_) async {});
      when(() => mockPlayer.setShuffle(any())).thenAnswer((_) async {});
      when(() => mockSaveCurrentPlayListUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await serviceImpl.openPlayList(
        _FakeMusicPlayerPlayListEntity(audiosT: [_FakeAudioItemEntity()]),
      );

      //assert
      verify(() => mockSaveCurrentPlayListUC.call(any())).called(1);
    });

    test("should call expected player methods with expected values when invokes", () async {
      //arrange
      when(() => mockPlayer.open(any(), play: any(named: "play"))).thenAnswer((_) async {});
      when(() => mockPlayer.setShuffle(any())).thenAnswer((_) async {});
      when(() => mockSaveCurrentPlayListUC.call(any())).thenAnswer((_) async => right(null));

      //act
      await serviceImpl.openPlayList(
        _FakeMusicPlayerPlayListEntity(audiosT: [_FakeAudioItemEntity()]),
      );

      //assert
      verify(
        () => mockPlayer.open(
          any(
            that: isA<Playlist>().having(
              (value) => value.medias.isNotEmpty,
              "list is not empty",
              true,
            ),
          ),
          play: false,
        ),
      ).called(1);

      verify(() => mockPlayer.setShuffle(false)).called(1);
    });
  });

  group("savePlayerControls -", () {
    test("should should call expected useCase with expected params when invoked", () async {
      //arrange
      when(() => mockMusicPlayerSaveControlsUC.call(any())).thenAnswer((_) async => right(null));
      when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
      when(() => mockPlayer.setPlaylistMode(any())).thenAnswer((_) async {});
      serviceImpl.cyclePlayListMode();
      serviceImpl.setVolume(521);

      //act
      await serviceImpl.savePlayerControls();

      //assert
      verify(
        () => mockMusicPlayerSaveControlsUC.call(
          any(
            that: isA<MusicPlayerSaveControlsParam>().having(
              (params) =>
                  params.volume == serviceImpl.volume &&
                  params.playListModeIndex == serviceImpl.playListMode.index,
              "has correct params",
              true,
            ),
          ),
        ),
      ).called(1);
    });

    test("should should call $Logger.e when result is a failure", () async {
      //arrange
      when(
        () => mockMusicPlayerSaveControlsUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockLogger.e(any())).thenAnswer((_) async {});

      //act
      await serviceImpl.savePlayerControls();

      //assert
      verify(() => mockLogger.e(any())).called(1);
    });
  });

  group("initializeMediaControls -", () {
    test("should call the expected useCase when invoked", () async {
      //arrange
      when(
        () => mockMusicPlayerGetControlsUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockLogger.e(any())).thenAnswer((_) async {});

      //act
      await serviceImpl.initializeMediaControls();

      //assert
      verify(() => mockMusicPlayerGetControlsUC.call(any())).called(1);
    });

    test("should call $Logger.e when result is a failure", () async {
      //arrange
      when(
        () => mockMusicPlayerGetControlsUC.call(any()),
      ).thenAnswer((_) async => left(_FakeFailure()));
      when(() => mockLogger.e(any())).thenAnswer((_) async {});

      //act
      await serviceImpl.initializeMediaControls();

      //assert
      verify(() => mockLogger.e(any())).called(1);
    });

    test("should set expected variables and call expected functionalities  when success", () async {
      //arrange
      final controls = MusicPlayerControlsEntity(volume: 22.25, playlistModeIndex: 2);
      when(() => mockMusicPlayerGetControlsUC.call(any())).thenAnswer((_) async => right(controls));
      when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
      when(() => mockPlayer.setPlaylistMode(any())).thenAnswer((_) async {});

      //act
      await serviceImpl.initializeMediaControls();

      //assert
      expect(serviceImpl.volume, controls.volume);
      expect(serviceImpl.playListMode.index, controls.playlistModeIndex);
      verify(() => mockPlayer.setVolume(controls.volume)).called(1);
      verify(
        () => mockPlayer.setPlaylistMode(PlaylistMode.values[controls.playlistModeIndex]),
      ).called(1);
    });
  });
}
