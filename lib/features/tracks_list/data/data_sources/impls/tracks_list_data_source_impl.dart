import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListDataSourceImpl implements TracksListDataSource {
  final FilePicker _filePicker;
  final Directory? _testDirectory;
  final Box<TracksListDirectoryModel> _directoriesBox;

  final audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];

  TracksListDataSourceImpl({
    required FilePicker filePicker,
    @visibleForTesting Directory? directory,
    Box<TracksListDirectoryModel>? testBox,
  }) : _filePicker = filePicker,
       _directoriesBox = testBox ?? Hive.box(HiveBoxesName.tracksList),
       _testDirectory = directory;

  @override
  Future<TracksListDirectoryModel?> pickDirectory(SortType sortType) async {
    final directoryPath = await _filePicker.getDirectoryPath();

    if (directoryPath == null) {
      return null;
    }

    Directory dir = _createDirectoryInstance(directoryPath);

    final Set<AudioItemModel> tracks = {};

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
      final item = await _createAudioModel(file);
      if (item != null) {
        tracks.add(item);
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
      id: const Uuid().v4(),
      directoryName: directoryName.capitalizeFirst ?? "",
      directoryPath: directoryPath,
      audios: tracks.toList(),
    );
  }

  Directory _createDirectoryInstance(String directoryPath) {
    late final Directory dir;
    if (_testDirectory == null) {
      dir = Directory(directoryPath);
    } else {
      dir = _testDirectory;
    }
    return dir;
  }

  Future<AudioItemModel?> _createAudioModel(File file) async {
    final ext = file.path.toLowerCase();

    final metaData = await MetadataRetriever.fromFile(File(file.path));

    if (audioExtensions.any((e) => ext.endsWith(e))) {
      return AudioItemModel(
        path: file.path,
        albumArt: metaData.albumArt,
        artistsNames: metaData.trackArtistNames,
        durationInSeconds: Duration(milliseconds: metaData.trackDuration ?? 0).inSeconds,
        trackName: file.uri.pathSegments.last,
        modifiedDate: file.statSync().modified.toIso8601String(),
        isFavorite: false,
      );
    }
    return null;
  }

  @override
  Future<void> saveDirectory(TracksListDirectoryModel dir) async {
    await _directoriesBox.add(dir);
  }

  @override
  Future<List<TracksListDirectoryModel>> getDirectories(SortType sortType) async {
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
    var itemKey = _getDirectoryKeyById(id);

    if (itemKey != null) {
      await _directoriesBox.delete(itemKey);
    }
  }

  dynamic _getDirectoryKeyById(String id) {
    final itemKey = _directoriesBox.keys.firstWhere(
      (key) => _directoriesBox.get(key)?.id == id,
      orElse: () => null,
    );
    return itemKey;
  }

  @override
  Future<bool> isDirectoryExists(String dirPath) async {
    final dir = _createDirectoryInstance(dirPath);

    return await dir.exists();
  }

  @override
  Future<void> syncAudios() async {
    final boxDirs = _directoriesBox.values.toList();

    for (var savedDir in boxDirs) {
      final systemDir = _createDirectoryInstance(savedDir.directoryPath);
      if (!await systemDir.exists()) return;

      final files = systemDir.listSync().whereType<File>();

      final savedFiles = savedDir.audios.map((e) => e.path).toList();

      final newFiles = files.where((e) => !savedFiles.contains(e.path));
      final removedFiles = savedFiles.where((e) => !files.map((e) => e.path).contains(e)).toList();

      if (newFiles.isNotEmpty) {
        for (var file in newFiles) {
          final item = await _createAudioModel(file);
          if (item != null) savedDir.audios.add(item);
        }

        final dirKey = _getDirectoryKeyById(savedDir.id);

        await _directoriesBox.put(dirKey, savedDir);
      }

      if (removedFiles.isNotEmpty) {
        for (var file in removedFiles) {
          savedDir.audios.removeWhere((e) => e.path == file);
        }

        final dirKey = _getDirectoryKeyById(savedDir.id);

        await _directoriesBox.put(dirKey, savedDir);
      }
    }
  }

  @override
  Future<bool> toggleAudioFavorite(TracksListToggleAudioFavoriteParams params) async {
    final dir = _directoriesBox.values.firstWhere((e) => e.id == params.dirId);

    final audio = dir.audios.firstWhere((e) => e.path == params.audioPath);

    final toggledFavorite = !audio.isFavorite;

    final updatedAudio = audio.copyWith(isFavorite: toggledFavorite);

    final dirKey = _getDirectoryKeyById(dir.id);

    dir.audios.remove(audio);

    dir.audios.add(updatedAudio);

    await _directoriesBox.put(dirKey, dir);

    return toggledFavorite;
  }

  @override
  Future<List<AudioItemModel>> getFavoriteSongs() async {
    final dirs = _directoriesBox.values;

    final favoriteSongs = dirs.expand((e) => e.audios.where((j) => j.isFavorite)).toList();

    return favoriteSongs;
  }
}
