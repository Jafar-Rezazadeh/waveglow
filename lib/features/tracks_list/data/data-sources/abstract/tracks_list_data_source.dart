import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListDataSource {
  Future<TracksListDirectoryModel?> pickDirectory();
  Future<void> saveDirectory(TracksListDirectoryEntity dir);
  Future<List<TracksListDirectoryEntity>> getDirectories();
}
