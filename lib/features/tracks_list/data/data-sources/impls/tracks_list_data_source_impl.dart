import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListDataSourceImpl implements TracksListDataSource {
  final FilePicker _filePicker;
  final Directory? _testDirectory;

  final audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];

  TracksListDataSourceImpl({
    required FilePicker filePicker,
    @visibleForTesting Directory? directory,
  }) : _filePicker = filePicker,
       _testDirectory = directory;

  @override
  Future<TracksListDirectoryModel?> pickDirectory() async {
    final directoryPath = await _filePicker.getDirectoryPath();

    if (directoryPath == null) {
      return null;
    }

    late final Directory dir;
    if (_testDirectory == null) {
      dir = Directory(directoryPath);
    } else {
      dir = _testDirectory;
    }

    final Set<AudioItemModel> tracks = {};

    await for (var file in dir.list(recursive: false, followLinks: false)) {
      final ext = file.path.toLowerCase();

      final metaData = await MetadataRetriever.fromFile(File(file.path));

      if (audioExtensions.any((e) => ext.endsWith(e))) {
        tracks.add(
          AudioItemModel(
            path: file.path,
            albumArt: metaData.albumArt,
            artistsNames: metaData.trackArtistNames,
            duration: Duration(milliseconds: metaData.trackDuration ?? 0),
            trackName: ext.substring(ext.lastIndexOf("\\") + 1),
          ),
        );
      }
    }
    final indexFolderNameStart = directoryPath.lastIndexOf("\\");
    String directoryName = "";
    if (indexFolderNameStart != -1) {
      directoryName = directoryPath.substring(indexFolderNameStart).replaceAll("\\", "");
    } else {
      directoryName = directoryPath;
    }

    return TracksListDirectoryModel(
      directoryName: directoryName.capitalizeFirst ?? "",
      directoryPath: directoryPath,
      audios: tracks.toList(),
    );
  }
}
