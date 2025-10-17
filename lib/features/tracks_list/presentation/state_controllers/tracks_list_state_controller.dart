import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListStateController extends GetxController {
  final MusicPlayerService _musicPlayerService;
  final CustomDialogs _customDialogs;
  final PickTracksListDirectoryUC _pickTracksListDirectoryUC;

  TracksListStateController({
    required PickTracksListDirectoryUC pickTracksListDirectoryUC,
    required MusicPlayerService musicPlayerService,
    required CustomDialogs customDialogs,
  }) : _pickTracksListDirectoryUC = pickTracksListDirectoryUC,
       _musicPlayerService = musicPlayerService,
       _customDialogs = customDialogs;

  final _allDirectories = RxList<TracksListDirectoryEntity>([]);
  final _isLoadingDir = false.obs;

  @visibleForTesting
  set setAllDirectories(List<TracksListDirectoryEntity> list) {
    _allDirectories.value = list;
  }

  List<TracksListDirectoryEntity> get allDirectories => _allDirectories;
  bool get isLoadingDir => _isLoadingDir.value;

  Future<void> pickDirectory() async {
    _isLoadingDir.value = true;

    final result = await _pickTracksListDirectoryUC.call(NoParams());

    result.fold((failure) => _customDialogs.showFailure(failure), (data) {
      if (data != null) {
        _allDirectories.add(data);
      }
    });

    _isLoadingDir.value = false;
  }

  void removeDirectory(TracksListDirectoryEntity dir) {
    _allDirectories.remove(dir);
  }

  Future<void> playTrack(AudioItemEntity item) async {
    await _musicPlayerService.open([item], play: true);
  }
}
