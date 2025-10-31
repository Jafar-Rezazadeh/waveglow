import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hive/hive.dart';
import 'package:waveglow/core/constants/enums.dart';
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
  Future<TracksListDirectoryModel?> pickDirectory(SortType sortType) async {
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

    // Collect all files into a list
    final entities = await dir.list(recursive: false, followLinks: false).toList();

    // Filter only files (ignore directories)
    final files = entities.whereType<File>().toList();

    // Sort files by givenType
    if (sortType == SortType.byModifiedDate) {
      files.sort((a, b) {
        final aMod = a.statSync().modified;
        final bMod = b.statSync().modified;
        return bMod.compareTo(aMod); // newest → oldest
      });
    }

    if (sortType == SortType.byTitle) {
      files.sort((a, b) {
        final aName = a.uri.pathSegments.last;
        final bName = b.uri.pathSegments.last;

        return aName.compareTo(bName);
      });
    }

    for (var file in files) {
      final ext = file.path.toLowerCase();

      final metaData = await MetadataRetriever.fromFile(File(file.path));

      if (audioExtensions.any((e) => ext.endsWith(e))) {
        tracks.add(
          AudioItemEntity(
            path: file.path,
            albumArt: metaData.albumArt,
            artistsNames: metaData.trackArtistNames,
            durationInSeconds: Duration(milliseconds: metaData.trackDuration ?? 0).inSeconds,
            trackName: file.uri.pathSegments.last,
            modifiedDate: file.statSync().modified.toIso8601String(),
            isFavorite: false,
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
  Future<List<TracksListDirectoryEntity>> getDirectories(SortType sortType) async {
    final dirs = _directoriesBox.values.toList();

    for (var dir in dirs) {
      dir.audios.sort((a, b) {
        switch (sortType) {
          case SortType.byModifiedDate:
            return b.modifiedDate.compareTo(a.modifiedDate);

          case SortType.byTitle:
            return (a.trackName?.toLowerCase() ?? "").compareTo(b.trackName?.toLowerCase() ?? "");

          case SortType.byFavorite:
            if (a.isFavorite == b.isFavorite) return 0;
            return a.isFavorite ? -1 : 1;
        }
      });
    }

    return dirs;
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

  @override
  Future<bool> isDirectoryExists(String dirPath) async {
    late final Directory dir;
    if (_testDirectory == null) {
      dir = Directory(dirPath);
    } else {
      dir = _testDirectory;
    }

    return await dir.exists();
  }
}
