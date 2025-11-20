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

void main() {
  late _MockMusicPlayerGetLastSavedPlaylistUC mockGetLastSavedPlaylistUC;
  late _MockMusicPlayerSaveCurrentPlayListUC mockSaveCurrentPlayListUC;
  late _MockPlayer mockPlayer;
  late _MockLogger mockLogger;
  late MusicPlayerServiceImpl serviceImpl;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(_FakePlaylist());
    registerFallbackValue(_FakeMusicPlayerPlayListEntity());
  });

  setUp(() {
    mockGetLastSavedPlaylistUC = _MockMusicPlayerGetLastSavedPlaylistUC();
    mockSaveCurrentPlayListUC = _MockMusicPlayerSaveCurrentPlayListUC();
    mockPlayer = _MockPlayer();
    mockLogger = _MockLogger();
    serviceImpl = MusicPlayerServiceImpl(
      player: mockPlayer,
      saveCurrentPlayListUC: mockSaveCurrentPlayListUC,
      getLastSavedPlaylistUC: mockGetLastSavedPlaylistUC,
      logger: mockLogger,
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
}
