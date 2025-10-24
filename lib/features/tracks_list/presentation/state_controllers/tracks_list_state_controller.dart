import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListStateController extends GetxController {
  final MusicPlayerService _musicPlayerService;
  final CustomDialogs _customDialogs;
  final PickTracksListDirectoryUC _pickTracksListDirectoryUC;
  final SaveTracksListDirectoryUC _saveDirectoryUC;
  final GetTrackListDirectoriesUC _getDirectoriesUC;
  final _allDirectories = RxList<TracksListDirectoryEntity>([]);
  String? _currentDirId;
  final _isLoadingDir = false.obs;

  TracksListStateController({
    required PickTracksListDirectoryUC pickTracksListDirectoryUC,
    required MusicPlayerService musicPlayerService,
    required SaveTracksListDirectoryUC saveDirectoryUC,
    required GetTrackListDirectoriesUC getDirectoriesUC,
    required CustomDialogs customDialogs,
  }) : _pickTracksListDirectoryUC = pickTracksListDirectoryUC,
       _musicPlayerService = musicPlayerService,
       _saveDirectoryUC = saveDirectoryUC,
       _getDirectoriesUC = getDirectoriesUC,
       _customDialogs = customDialogs;

  @visibleForTesting
  set setAllDirectories(List<TracksListDirectoryEntity> list) {
    _allDirectories.value = list;
  }

  @visibleForTesting
  set setCurrentDirKey(String? value) => _currentDirId = value;

  @visibleForTesting
  String? get currentDirKey => _currentDirId;

  List<TracksListDirectoryEntity> get allDirectories => _allDirectories;
  bool get isLoadingDir => _isLoadingDir.value;

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    _isLoadingDir.value = true;

    await getDirectories();

    _isLoadingDir.value = false;
  }

  Future<void> pickDirectory() async {
    _isLoadingDir.value = true;

    final result = await _pickTracksListDirectoryUC.call(NoParams());

    result.fold(
      (failure) {
        _customDialogs.showFailure(failure);
      },
      (dir) {
        if (dir != null) {
          _allDirectories.add(dir);
          saveDirectory(dir);
        }
      },
    );

    _isLoadingDir.value = false;
  }

  void removeDirectory(TracksListDirectoryEntity dir) {
    _allDirectories.remove(dir);
  }

  Future<void> playTrack(AudioItemEntity item, String dirId) async {
    if (dirId != _currentDirId || _musicPlayerService.currentPlaylist.isEmpty) {
      final dirAudiosItems = _allDirectories.firstWhereOrNull((e) => e.id == dirId)?.audios ?? [];

      await _musicPlayerService.openPlayList(dirAudiosItems, play: false);
    }

    final itemIndex = _musicPlayerService.currentPlaylist.indexOf(item);

    if (itemIndex != -1) {
      await _musicPlayerService.playAt(itemIndex);
    }

    _currentDirId = dirId;
  }

  @visibleForTesting
  Future<void> saveDirectory(TracksListDirectoryEntity dir) async {
    final result = await _saveDirectoryUC.call(dir);

    result.fold((failure) => _customDialogs.showFailure(failure), (_) {});
  }

  @visibleForTesting
  Future<void> getDirectories() async {
    final result = await _getDirectoriesUC.call(NoParams());

    result.fold(
      (failure) => _customDialogs.showFailure(failure),
      (directories) => _allDirectories.addAll(directories),
    );
  }
}
