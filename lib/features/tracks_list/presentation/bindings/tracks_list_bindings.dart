import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListBindings extends Bindings {
  final FilePicker? _filePicker;

  TracksListBindings({@visibleForTesting FilePicker? filePicker}) : _filePicker = filePicker;

  @override
  void dependencies() {
    // data-source
    final dataSource = TracksListDataSourceImpl(filePicker: _filePicker ?? FilePicker.platform);

    // repositories
    final repository = TracksListRepositoryImpl(
      dataSource: dataSource,
      failureFactory: FailureFactory(),
    );

    // repositories
    final pickTracksListDirectoryUC = PickTracksListDirectoryUC(repository: repository);

    // controllers
    Get.put(
      TracksListStateController(
        pickTracksListDirectoryUC: pickTracksListDirectoryUC,
        customDialogs: CustomDialogs(),
      ),
    );
  }
}
