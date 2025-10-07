import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/features/tracks_list/data/models/tracks_list_audio_item_model.dart';

void main() {
  group("fromMetaData -", () {
    test("should return expected result based on given $Metadata object ", () {
      //arrange
      final metaData = Metadata(
        albumArt: Uint8List.fromList([1]),
        trackName: "trackName",
        trackArtistNames: ["artist1"],
        trackDuration: 60000,
      );
      const path = "f:/media/music.mp3";

      //act
      final result = TracksListAudioItemModel.fromMetaData(metaData, path);

      //assert
      expect(result.albumArt, metaData.albumArt);
      expect(result.trackName, metaData.trackName);
      expect(result.trackArtistNames, metaData.trackArtistNames);
      expect(result.trackDuration?.inMilliseconds, metaData.trackDuration);
      expect(result.path, path);
    });
  });
}
