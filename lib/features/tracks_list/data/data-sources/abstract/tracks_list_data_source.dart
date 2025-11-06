import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListDataSource {
  Future<TracksListDirectoryModel?> pickDirectory(SortType sortType);
  Future<void> saveDirectory(TracksListDirectoryModel dir);
  // TODO: change the return result to model
  Future<List<TracksListDirectoryEntity>> getDirectories(SortType sortType);
  Future<void> deleteDir(String id);
  Future<bool> isDirectoryExists(String dirPath);
}
