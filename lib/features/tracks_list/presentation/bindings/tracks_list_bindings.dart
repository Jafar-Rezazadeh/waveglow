import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListBindings extends Bindings {
  final FilePicker? _filePicker;
  final Box<TracksListDirectoryEntity>? _testBox;

  TracksListBindings({
    @visibleForTesting FilePicker? filePicker,
    @visibleForTesting Box<TracksListDirectoryEntity>? testBox,
  }) : _filePicker = filePicker,
       _testBox = testBox;

  @override
  void dependencies() {
    // extras
    final musicPlayerService = Get.find<MusicPlayerService>();

    // data-source
    final dataSource = TracksListDataSourceImpl(
      filePicker: _filePicker ?? FilePicker.platform,
      testBox: _testBox,
    );

    // repositories
    final repository = TracksListRepositoryImpl(
      dataSource: dataSource,
      failureFactory: FailureFactory(),
    );

    // repositories
    final pickTracksListDirectoryUC = PickTracksListDirectoryUC(repository: repository);
    final saveDirectoryUC = SaveTracksListDirectoryUC(repository: repository);
    final getDirectoriesUC = GetTrackListDirectoriesUC(repository: repository);
    final deleteDirectoryUC = DeleteTracksListDirectoryUC(repository: repository);

    // controllers
    Get.put(
      TracksListStateController(
        pickTracksListDirectoryUC: pickTracksListDirectoryUC,
        musicPlayerService: musicPlayerService,
        saveDirectoryUC: saveDirectoryUC,
        getDirectoriesUC: getDirectoriesUC,
        deleteDirectoryUC: deleteDirectoryUC,
        customDialogs: CustomDialogs(),
      ),
    );
  }
}
