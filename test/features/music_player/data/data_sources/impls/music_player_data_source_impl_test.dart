import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';

class _MockBox extends Mock implements Box<MusicPlayerPlayListModel> {}

class _FakeMusicPlayerPlayListModel extends Fake implements MusicPlayerPlayListModel {}

void main() {
  late _MockBox mockBox;
  late MusicPlayerDataSourceImpl dataSourceImpl;

  setUpAll(() {
    registerFallbackValue(_FakeMusicPlayerPlayListModel());
  });

  setUp(() {
    mockBox = _MockBox();
    dataSourceImpl = MusicPlayerDataSourceImpl(testMusicPlayerBox: mockBox);
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
}
