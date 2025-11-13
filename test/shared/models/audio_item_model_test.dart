import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/core/core_exports.dart';

void main() {
  group("fromEntity -", () {
    test("should return expected result ", () {
      //arrange
      final entity = AudioItemEntity(
        path: "path",
        trackName: "trackName",
        albumArt: Uint8List.fromList([]),
        durationInSeconds: 686,
        artistsNames: ["artistsNames"],
        modifiedDate: "modifiedDate",
        isFavorite: false,
      );

      //act
      final result = AudioItemModel.fromEntity(entity);

      //assert
      expect(result.path, entity.path);
      expect(result.trackName, entity.trackName);
      expect(result.albumArt, entity.albumArt);
      expect(result.durationInSeconds, entity.durationInSeconds);
      expect(result.artistsNames, entity.artistsNames);
      expect(result.modifiedDate, entity.modifiedDate);
      expect(result.isFavorite, entity.isFavorite);
    });
  });

  group("toEntity -", () {
    test("should return expected result ", () {
      //arrange
      final model = AudioItemModel(
        path: "path",
        trackName: "trackName",
        albumArt: Uint8List.fromList([5]),
        durationInSeconds: 827,
        artistsNames: ["artistsNames"],
        modifiedDate: "modifiedDate",
        isFavorite: false,
      );

      //act
      final result = model.toEntity();

      //assert
      expect(result.path, model.path);
      expect(result.trackName, model.trackName);
      expect(result.albumArt, model.albumArt);
      expect(result.durationInSeconds, model.durationInSeconds);
      expect(result.artistsNames, model.artistsNames);
      expect(result.modifiedDate, model.modifiedDate);
      expect(result.isFavorite, model.isFavorite);
    });
  });

  group("copyWith -", () {
    test("should change the give prop but others ", () {
      //arrange
      final audio = AudioItemModel(
        path: "path",
        trackName: "trackName",
        albumArt: Uint8List.fromList([5]),
        durationInSeconds: 5,
        artistsNames: ["artistsNames"],
        modifiedDate: "modifiedDate",
        isFavorite: false,
      );

      //act
      final result = audio.copyWith(isFavorite: true);

      //assert
      expect(result.path, audio.path);
      expect(result.trackName, audio.trackName);
      expect(result.albumArt, audio.albumArt);
      expect(result.durationInSeconds, audio.durationInSeconds);
      expect(result.artistsNames, audio.artistsNames);
      expect(result.modifiedDate, audio.modifiedDate);
      expect(result.isFavorite, true);
    });
  });
}
