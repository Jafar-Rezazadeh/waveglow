import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListDataSource {
  Future<TracksListDirectoryModel?> pickDirectory(SortTypeEnum sortType);
  Future<void> saveDirectory(TracksListDirectoryModel dir);
  Future<List<TracksListDirectoryModel>> getDirectories(SortTypeEnum sortType);
  Future<void> deleteDir(String id);
  Future<bool> isDirectoryExists(String dirPath);
  Future<void> syncAudios();
  Future<bool> toggleAudioFavorite(AudioItemModel item);
  Future<List<AudioItemModel>> getFavoriteSongs();
  Future<Stream<List<AudioItemModel>>> getFavoriteSongsStream();
}
