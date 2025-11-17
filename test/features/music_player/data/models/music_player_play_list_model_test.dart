import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/features/music_player/music_player_exports.dart';
import 'package:waveglow/shared/models/audio_item_model.dart';

void main() {
  final audioItem = AudioItemModel(
    path: "path",
    trackName: "trackName",
    albumArt: Uint8List.fromList([4]),
    durationInSeconds: 25,
    artistsNames: ["artistsNames"],
    modifiedDate: "modifiedDate",
    isFavorite: true,
  );

  group("fromEntity -", () {
    test("should return expected result ", () {
      //arrange
      final entity = MusicPlayerPlayListEntity(id: "id", audios: [audioItem.toEntity()]);

      //act
      final result = MusicPlayerPlayListModel.fromEntity(entity);

      //assert
      expect(result.id, entity.id);
      expect(result.audios.first.path, entity.audios.first.path);
    });
  });
  group("toEntity -", () {
    test("should return expected result ", () {
      //arrange
      final model = MusicPlayerPlayListModel(id: "id", audios: [audioItem]);

      //act
      final result = model.toEntity();

      //assert
      expect(result.id, model.id);
      expect(result.audios.first.path, model.audios.first.path);
    });
  });
}
