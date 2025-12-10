import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/utils/test_mode_checker.dart';
import 'package:waveglow/features/music_player/domain/entities/music_player_play_list_entity.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';
import 'package:waveglow/shared/utils/custom_metadata_cacher.dart';
import 'package:waveglow/shared/utils/custom_task_queue.dart';

class TracksListStateController extends GetxController {
  final MusicPlayerService _musicPlayerService;
  final CustomDialogs _customDialogs;
  final PickTracksListDirectoryUC _pickTracksListDirectoryUC;
  final SaveTracksListDirectoryUC _saveDirectoryUC;
  final GetTrackListDirectoriesUC _getDirectoriesUC;
  final DeleteTracksListDirectoryUC _deleteDirectoryUC;
  final IsTracksListDirectoryExistsUC _isDirectoryExistsUC;
  final TracksListSyncAudiosUC _syncAudiosUC;
  final TracksListToggleAudioFavoriteUC _toggleAudioFavoriteUC;
  final CustomTaskQueue _customTaskQueue;
  final currentTapIndex = Rx<int>(0);
  final _allDirectories = RxList<TracksListDirectoryTemplate>([]);

  final _isLoadingDir = false.obs;

  TracksListStateController({
    required PickTracksListDirectoryUC pickTracksListDirectoryUC,
    required MusicPlayerService musicPlayerService,
    required SaveTracksListDirectoryUC saveDirectoryUC,
    required GetTrackListDirectoriesUC getDirectoriesUC,
    required DeleteTracksListDirectoryUC deleteDirectoryUC,
    required IsTracksListDirectoryExistsUC isDirectoryExistsUC,
    required TracksListSyncAudiosUC tracksListSyncAudiosUC,
    required TracksListToggleAudioFavoriteUC toggleAudioFavoriteUC,
    required CustomTaskQueue taskQueue,
    required CustomDialogs customDialogs,
  }) : _pickTracksListDirectoryUC = pickTracksListDirectoryUC,
       _musicPlayerService = musicPlayerService,
       _saveDirectoryUC = saveDirectoryUC,
       _getDirectoriesUC = getDirectoriesUC,
       _deleteDirectoryUC = deleteDirectoryUC,
       _isDirectoryExistsUC = isDirectoryExistsUC,
       _syncAudiosUC = tracksListSyncAudiosUC,
       _toggleAudioFavoriteUC = toggleAudioFavoriteUC,
       _customTaskQueue = taskQueue,
       _customDialogs = customDialogs;

  @visibleForTesting
  set setAllDirectories(List<TracksListDirectoryTemplate> list) {
    _allDirectories.value = list;
  }

  List<TracksListDirectoryTemplate> get allDirectories => _allDirectories;
  bool get isLoadingDir => _isLoadingDir.value;

  @override
  void onInit() {
    super.onInit();
    rxListeners();
    if (!TestModeChecker.isTestMode()) {
      initData();
    }
  }

  void rxListeners() {
    ever(currentTapIndex, (index) {
      _loadCurrentDirTracksMetaData(index);
    });
  }

  Future<void> _loadCurrentDirTracksMetaData(int index) async {
    if (_allDirectories.isNotEmpty) {
      final dir = _allDirectories[index].dirEntity;

      for (var audio in dir.audios) {
        _customTaskQueue.add(() async {
          await CustomMetaDataCacher.loadMetaData(audio.path);
        });
      }
    }
  }

  @visibleForTesting
  Future<void> initData() async {
    _isLoadingDir.value = true;
    await getDirectories();

    _isLoadingDir.value = false;
  }

  void setInitTabIndex() {
    final index = _allDirectories.indexWhere(
      (e) => e.dirEntity.id == _musicPlayerService.currentPlaylist?.id,
    );

    if (index != -1) {
      currentTapIndex.value = index;
    } else {
      currentTapIndex.value = 0;
    }
  }

  Future<void> pickDirectory() async {
    _isLoadingDir.value = true;

    final result = await _pickTracksListDirectoryUC.call();

    await result.fold(
      (failure) {
        _customDialogs.showFailure(failure);
      },
      (dir) async {
        if (dir != null) {
          _allDirectories.add(TracksListDirectoryTemplate(isExists: true, dirEntity: dir));
          saveDirectory(dir);
          final index = _allDirectories.indexWhere((e) => e.dirEntity.id == dir.id);
          currentTapIndex.value = index;
          _loadCurrentDirTracksMetaData(index);
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

  Future<void> playTrack(AudioItemEntity item) async {
    if (_dirIsDifferentOrPlaylistDoesNOTContainAudio(item)) {
      await _openSelectedDirectoryAudios(item.dirId);
    }

    final itemIndex =
        _musicPlayerService.currentPlaylist?.audios.indexWhere((e) => e.path == item.path) ?? -1;

    if (itemIndex != -1) {
      await _musicPlayerService.playAt(itemIndex);
    }
  }

  bool _dirIsDifferentOrPlaylistDoesNOTContainAudio(AudioItemEntity item) {
    return item.dirId != _musicPlayerService.currentPlaylist?.id ||
        _musicPlayerService.currentPlaylist?.audios.any((e) => e.path == item.path) == false;
  }

  Future<void> _openSelectedDirectoryAudios(String dirId) async {
    final dirAudiosItems =
        _allDirectories.firstWhereOrNull((e) => e.dirEntity.id == dirId)?.dirEntity.audios ?? [];

    final playList = MusicPlayerPlayListEntity(id: dirId, audios: dirAudiosItems);

    await _musicPlayerService.openPlayList(playList, play: false);
  }

  @visibleForTesting
  Future<void> saveDirectory(TracksListDirectoryEntity dir) async {
    final result = await _saveDirectoryUC.call(dir);

    result.fold((failure) => _customDialogs.showFailure(failure), (_) {});
  }

  @visibleForTesting
  Future<void> getDirectories() async {
    await _syncAudiosUC.call(NoParams());

    final result = await _getDirectoriesUC.call();

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

  @visibleForTesting
  Future<bool> isExistedDirectories(String dirPath) async {
    final result = await _isDirectoryExistsUC.call(dirPath);

    return result.fold((l) => false, (r) => r);
  }

  Future<void> toggleAudioFavorite(AudioItemEntity item) async {
    final result = await _toggleAudioFavoriteUC.call(item);

    result.fold(
      (failure) {
        return _customDialogs.showFailure(failure);
      },
      (isFavorite) {
        final dirIndex = _allDirectories.indexWhere((e) => e.dirEntity.id == item.dirId);
        final dirTemp = _allDirectories[dirIndex];

        final updatedAudio = item.copyWith(isFavorite: isFavorite);

        final indexOdAudio = dirTemp.dirEntity.audios.indexOf(item);
        if (indexOdAudio != -1) {
          dirTemp.dirEntity.audios[indexOdAudio] = updatedAudio;
        }

        _allDirectories[dirIndex] = dirTemp;
      },
    );
  }
}
