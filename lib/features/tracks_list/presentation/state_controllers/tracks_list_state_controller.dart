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
  final DeleteTracksListDirectoryUC _deleteDirectoryUC;
  final IsTracksListDirectoryExistsUC _isDirectoryExistsUC;
  final _allDirectories = RxList<TracksListDirectoryTemplate>([]);

  String? _currentPlayingMusicDirId;
  final _isLoadingDir = false.obs;

  TracksListStateController({
    required PickTracksListDirectoryUC pickTracksListDirectoryUC,
    required MusicPlayerService musicPlayerService,
    required SaveTracksListDirectoryUC saveDirectoryUC,
    required GetTrackListDirectoriesUC getDirectoriesUC,
    required DeleteTracksListDirectoryUC deleteDirectoryUC,
    required IsTracksListDirectoryExistsUC isDirectoryExistsUC,
    required CustomDialogs customDialogs,
  }) : _pickTracksListDirectoryUC = pickTracksListDirectoryUC,
       _musicPlayerService = musicPlayerService,
       _saveDirectoryUC = saveDirectoryUC,
       _getDirectoriesUC = getDirectoriesUC,
       _deleteDirectoryUC = deleteDirectoryUC,
       _isDirectoryExistsUC = isDirectoryExistsUC,
       _customDialogs = customDialogs;

  @visibleForTesting
  set setAllDirectories(List<TracksListDirectoryTemplate> list) {
    _allDirectories.value = list;
  }

  @visibleForTesting
  set setCurrentDirKey(String? value) => _currentPlayingMusicDirId = value;

  @visibleForTesting
  String? get currentDirKey => _currentPlayingMusicDirId;

  List<TracksListDirectoryTemplate> get allDirectories => _allDirectories;
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

  @visibleForTesting
  Future<bool> isExistedDirectories(String dirPath) async {
    final result = await _isDirectoryExistsUC.call(dirPath);

    return result.fold((l) => false, (r) => r);
  }

  Future<void> pickDirectory() async {
    _isLoadingDir.value = true;

    final result = await _pickTracksListDirectoryUC.call(NoParams());

    await result.fold(
      (failure) {
        _customDialogs.showFailure(failure);
      },
      (dir) async {
        if (dir != null) {
          _allDirectories.add(TracksListDirectoryTemplate(isExists: true, dirEntity: dir));
          saveDirectory(dir);
        }
      },
    );

    _isLoadingDir.value = false;
  }

  Future<void> removeDirectory(TracksListDirectoryTemplate dirTemplate) async {
    final result = await _deleteDirectoryUC.call(dirTemplate.dirEntity.id);

    result.fold(
      (failure) {
        _customDialogs.showFailure(failure);
      },
      (_) {
        _allDirectories.remove(dirTemplate);
      },
    );
  }

  Future<void> playTrack(AudioItemEntity item, String dirId) async {
    if (dirId != _currentPlayingMusicDirId || _musicPlayerService.currentPlaylist.isEmpty) {
      final dirAudiosItems =
          _allDirectories.firstWhereOrNull((e) => e.dirEntity.id == dirId)?.dirEntity.audios ?? [];

      await _musicPlayerService.openPlayList(dirAudiosItems, play: false);
    }

    final itemIndex = _musicPlayerService.currentPlaylist.indexOf(item);

    if (itemIndex != -1) {
      await _musicPlayerService.playAt(itemIndex);
    }

    _currentPlayingMusicDirId = dirId;
  }

  @visibleForTesting
  Future<void> saveDirectory(TracksListDirectoryEntity dir) async {
    final result = await _saveDirectoryUC.call(dir);

    result.fold((failure) => _customDialogs.showFailure(failure), (_) {});
  }

  @visibleForTesting
  Future<void> getDirectories() async {
    final result = await _getDirectoriesUC.call(NoParams());

    await result.fold((failure) => _customDialogs.showFailure(failure), (directories) async {
      final dirTemplates = await Future.wait(
        directories.map((e) async {
          final isExists = await isExistedDirectories(e.directoryPath);
          return TracksListDirectoryTemplate(isExists: isExists, dirEntity: e);
        }).toList(),
      );

      _allDirectories.addAll(dirTemplates);
    });
  }
}
