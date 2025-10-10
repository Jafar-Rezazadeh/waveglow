import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:waveglow/features/tracks_list/data/models/tracks_list_audio_item_model.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListDataSourceImpl implements TracksListDataSource {
  final FilePicker _filePicker;
  Directory? _directory;

  final audioExtensions = ['.mp3', '.wav', '.aac', '.m4a', '.flac', '.ogg'];

  TracksListDataSourceImpl({
    required FilePicker filePicker,
    @visibleForTesting Directory? directory,
  })  : _filePicker = filePicker,
        _directory = directory;

  @override
  Future<TracksListDirectoryModel?> pickDirectory() async {
    final directoryPath = await _filePicker.getDirectoryPath();

    if (directoryPath == null) {
      return null;
    }

    _directory ??= Directory(directoryPath);

    final Set<TracksListAudioItemModel> tracks = {};

    await for (var file in _directory!.list(recursive: true, followLinks: false)) {
      final ext = file.path.toLowerCase();

      if (audioExtensions.any((e) => ext.endsWith(e))) {
        final metaData = await MetadataRetriever.fromFile(File(file.path));

        tracks.add(
          TracksListAudioItemModel(
            trackName: ext.substring(ext.lastIndexOf("\\") + 1),
            trackArtistNames: metaData.trackArtistNames,
            isFavorite: false,
            trackDuration: metaData.trackDuration != null
                ? Duration(milliseconds: metaData.trackDuration!)
                : null,
            albumArt: metaData.albumArt,
            path: file.path,
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
