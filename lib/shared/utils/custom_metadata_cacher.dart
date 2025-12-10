import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class CustomMetaDataCacher {
  static final Map<String, Metadata?> cachedData = {};

  static Future<Metadata?> loadMetaData(String imagePath) async {
    if (cachedData.keys.contains(imagePath)) {
      return cachedData[imagePath];
    }

    final metaData = await MetadataRetriever.fromFile(File(imagePath));

    final data = {imagePath: metaData};

    cachedData.addAll(data);

    return metaData;
  }

  static Metadata? getMetaData(String path) {
    return cachedData.entries.where((e) => e.key == path).firstOrNull?.value;
  }
}
