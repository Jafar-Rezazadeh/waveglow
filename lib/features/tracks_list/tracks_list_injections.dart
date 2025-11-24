import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

Future<void> initTracksListInjections() async {
  // dataSource
  final dataSource = TracksListDataSourceImpl(filePicker: FilePicker.platform);

  // repositories
  final repository = TracksListRepositoryImpl(
    dataSource: dataSource,
    failureFactory: FailureFactory(),
  );

  // useCases
  final getFavoriteSongsUC = TracksListGetFavoriteSongsUC(repository: repository);
  final getFavoriteSongsStreamUC = TracksListGetFavoriteSongsStreamUC(repository: repository);

  // services
  Get.put<TracksListService>(
    TracksListServiceImpl(
      getFavoriteSongsUC: getFavoriteSongsUC,
      getFavoriteSongsStreamUC: getFavoriteSongsStreamUC,
    ),
  );
}
