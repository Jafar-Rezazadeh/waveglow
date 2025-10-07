import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListStateController extends GetxController {
  final CustomDialogs _customDialogs;
  final PickTracksListDirectoryUC _pickTracksListDirectoryUC;

  TracksListStateController({
    required PickTracksListDirectoryUC pickTracksListDirectoryUC,
    required CustomDialogs customDialogs,
  })  : _pickTracksListDirectoryUC = pickTracksListDirectoryUC,
        _customDialogs = customDialogs;

  final _allDirectories = RxList<TracksListDirectoryEntity>([]);

  List<TracksListDirectoryEntity> get allDirectories => _allDirectories;

  Future<void> pickDirectory() async {
    final result = await _pickTracksListDirectoryUC.call(NoParams());

    result.fold(
      (failure) => _customDialogs.showFailure(failure),
      (data) {
        if (data != null) {
          _allDirectories.add(data);
        }
      },
    );
  }
}
