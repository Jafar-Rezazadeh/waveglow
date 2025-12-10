import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waveglow/shared/utils/custom_metadata_cacher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      MethodChannel("flutter_media_metadata"),
      (message) {
        if (message.method == "MetadataRetriever") {
          return Future.value({
            "metadata": {
              'trackName': "trackName",
              'trackArtistNames': "trackArtistNames/name2",
              'albumName': "albumName",
              'albumArtistName': "albumArtistName",
              'trackNumber': 5,
              'albumLength': 1,
              'year': 1,
              'genre': "genre",
              'authorName': "authorName",
              'writerName': "writerName",
              'discNumber': 23,
              'mimeType': "mimeType",
              'trackDuration': 5,
              'bitrate': 3,
              'filePath': "filePath",
            },
          });
        }
        return null;
      },
    );
  });

  group("loadMetaData -", () {
    test("should load the metaData of given filePath ", () async {
      //arrange
      const filePath = "testPath";

      //act
      await CustomMetaDataCacher.loadMetaData(filePath);

      //assert
      expect(CustomMetaDataCacher.cachedData.keys, contains(filePath));
    });

    test(
      "should not get and add metaData when given filePath is already exists in the cachedData",
      () async {
        //arrange
        final file1 = "test";
        final file2 = "test";

        //act
        await CustomMetaDataCacher.loadMetaData(file1);
        await CustomMetaDataCacher.loadMetaData(file2);

        //assert
        expect(CustomMetaDataCacher.cachedData.entries.length, 1);
      },
    );
  });

  group("getMetaData -", () {
    test("should should return expected result from images ", () async {
      //arrange
      final file = "test2";

      //act
      await CustomMetaDataCacher.loadMetaData(file);

      //assert
      expect(CustomMetaDataCacher.getMetaData(file), isNotNull);
    });
  });
}
