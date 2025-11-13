import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

void main() {
  group("fromEntity -", () {
    test("should return expected result ", () {
      //arrange
      final entity = TracksListDirectoryEntity(
        id: "id",
        directoryName: "directoryName",
        directoryPath: "directoryPath",
        audios: [
          AudioItemEntity(
            path: "path",
            trackName: "trackName",
            albumArt: Uint8List.fromList([]),
            durationInSeconds: 2,
            artistsNames: ["artistsNames"],
            modifiedDate: "modifiedDate",
            isFavorite: false,
          ),
        ],
      );

      //act
      final result = TracksListDirectoryModel.fromEntity(entity);

      //assert
      expect(result.id, entity.id);
      expect(result.directoryName, entity.directoryName);
      expect(result.directoryPath, entity.directoryPath);
      expect(result.audios.first.path, entity.audios.first.path);
    });
  });

  group("toEntity -", () {
    test("should return expected entity with expected result  ", () {
      //arrange
      final model = TracksListDirectoryModel(
        id: "125",
        directoryName: "directoryName",
        directoryPath: "directoryPath",
        audios: [
          AudioItemModel(
            path: "path_",
            trackName: "trackName_",
            albumArt: Uint8List.fromList([]),
            durationInSeconds: 24,
            artistsNames: ["artistsNames_"],
            modifiedDate: "modifiedDate_",
            isFavorite: false,
          ),
        ],
      );

      //act
      final result = model.toEntity();

      //assert
      expect(result.id, model.id);
      expect(result.directoryName, model.directoryName);
      expect(result.directoryPath, model.directoryPath);
      expect(result.audios.first.path, model.audios.first.path);
    });
  });
}
