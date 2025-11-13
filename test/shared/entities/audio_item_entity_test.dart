import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/core/core_exports.dart';

void main() {
  group("copyWith -", () {
    test("should change the expected prop but keeps the other ", () {
      //arrange
      final entity = AudioItemEntity(
        path: "path",
        trackName: "trackName",
        albumArt: Uint8List.fromList([]),
        durationInSeconds: 24,
        artistsNames: ["artistsNames"],
        modifiedDate: "modifiedDate",
        isFavorite: false,
      );

      //act
      final result = entity.copyWith(isFavorite: true);

      //assert
      expect(result.path, entity.path);
      expect(result.trackName, entity.trackName);
      expect(result.albumArt, entity.albumArt);
      expect(result.durationInSeconds, entity.durationInSeconds);
      expect(result.artistsNames, entity.artistsNames);
      expect(result.modifiedDate, entity.modifiedDate);
      expect(result.isFavorite, !entity.isFavorite);
    });
  });
}
