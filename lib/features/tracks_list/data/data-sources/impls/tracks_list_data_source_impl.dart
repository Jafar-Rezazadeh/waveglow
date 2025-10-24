import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListDataSourceImpl implements TracksListDataSource {
  final FilePicker _filePicker;
  final Directory? _testDirectory;
  final Box<TracksListDirectoryEntity> _directoriesBox;

  final audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];

  TracksListDataSourceImpl({
    required FilePicker filePicker,
    @visibleForTesting Directory? directory,
    Box<TracksListDirectoryEntity>? testBox,
  }) : _filePicker = filePicker,
       _directoriesBox = testBox ?? Hive.box(TracksListConstants.tracksListDirectoryBoxName),
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

    final Set<AudioItemEntity> tracks = {};

    await for (var file in dir.list(recursive: false, followLinks: false)) {
      final ext = file.path.toLowerCase();

      final metaData = await MetadataRetriever.fromFile(File(file.path));

      if (audioExtensions.any((e) => ext.endsWith(e))) {
        tracks.add(
          AudioItemEntity(
            path: file.path,
            albumArt: metaData.albumArt,
            artistsNames: metaData.trackArtistNames,
            durationInSeconds: Duration(milliseconds: metaData.trackDuration ?? 0).inSeconds,
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

  @override
  Future<void> saveDirectory(TracksListDirectoryEntity dir) async {
    await _directoriesBox.add(dir);
  }

  @override
  Future<List<TracksListDirectoryEntity>> getDirectories() async {
    return _directoriesBox.values.toList();
  }

  @override
  Future<void> deleteDir(String id) async {
    final itemKey = _directoriesBox.keys.firstWhere(
      (key) => _directoriesBox.get(key)?.id == id,
      orElse: () => null,
    );

    if (itemKey != null) {
      await _directoriesBox.delete(itemKey);
    }
  }
}
