import 'package:waveglow/features/tracks_list/data/models/tracks_list_directory_model.dart';

abstract class TracksListDataSource {
  Future<TracksListDirectoryModel?> pickDirectory();
}
