import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockBox extends Mock implements Box<MusicPlayerPlayListModel> {}

class _MockSharedPreferences extends Mock implements SharedPreferences {}

class _FakeMusicPlayerPlayListModel extends Fake implements MusicPlayerPlayListModel {}

void main() {
  late _MockBox mockBox;
  late _MockSharedPreferences mockSharedPreferences;
  late MusicPlayerDataSourceImpl dataSourceImpl;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerPlayListModel());
  });

  setUp(() {
    mockBox = _MockBox();
    mockSharedPreferences = _MockSharedPreferences();
    dataSourceImpl = MusicPlayerDataSourceImpl(
      testMusicPlayerBox: mockBox,
      sharedPreferences: mockSharedPreferences,
    );
  });

  group("saveCurrentPlayList -", () {
    test("should call put with expected key of box when invoked", () async {
      //arrange
      when(() => mockBox.put("play_list", any())).thenAnswer((_) async {});

      //act
      await dataSourceImpl.saveCurrentPlayList(_FakeMusicPlayerPlayListModel());

      //assert
      verify(() => mockBox.put("play_list", any())).called(1);
    });
  });

  group("getLastSavedPlaylist -", () {
    test(
      "should call get method of the box with expected key and return value when success",
      () async {
        //arrange
        when(() => mockBox.get("play_list")).thenAnswer((_) => _FakeMusicPlayerPlayListModel());

        //act
        final result = await dataSourceImpl.getLastSavedPlaylist();

        //assert
        expect(result, isA<MusicPlayerPlayListModel>());
      },
    );
  });

  group("saveMediaControls -", () {
    final mediaControlsParams = MusicPlayerSaveControlsParam(volume: 52, playListModeIndex: 2);

    test("should call expected functionality with expected keys when success", () async {
      //arrange
      when(() => mockSharedPreferences.setDouble("volume", any())).thenAnswer((_) async => true);
      when(
        () => mockSharedPreferences.setInt("playlist_mode", any()),
      ).thenAnswer((_) async => true);

      //act
      await dataSourceImpl.saveMediaControls(mediaControlsParams);

      //assert
      verify(() => mockSharedPreferences.setDouble("volume", any())).called(1);
      verify(() => mockSharedPreferences.setInt("playlist_mode", any())).called(1);
    });
  });

  group("getMediaControls -", () {
    test(
      "should call expected $SharedPreferences methods and return expected values when success ",
      () async {
        //arrange
        const volume = 10.5;
        const playListMode = 4;
        when(() => mockSharedPreferences.getDouble("volume")).thenAnswer((_) => volume);
        when(() => mockSharedPreferences.getInt("playlist_mode")).thenAnswer((_) => playListMode);

        //act
        final result = await dataSourceImpl.getMediaControls();

        //assert
        expect(result.volume, volume);
        expect(result.playlistModeIndex, playListMode);
      },
    );
  });
}
