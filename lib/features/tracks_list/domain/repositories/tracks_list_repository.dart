import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListRepository {
  Future<Either<Failure, TracksListDirectoryEntity?>> pickDirectory(SortTypeEnum sortType);
  Future<Either<Failure, void>> saveDirectory(TracksListDirectoryEntity dir);
  Future<Either<Failure, List<TracksListDirectoryEntity>>> getDirectories(SortTypeEnum sortType);
  Future<Either<Failure, void>> deleteDir(String id);
  Future<Either<Failure, bool>> isDirectoryExists(String dirPath);
  Future<Either<Failure, void>> syncAudios();
  Future<Either<Failure, bool>> toggleAudioFavorite(AudioItemEntity item);
  Future<Either<Failure, List<AudioItemEntity>>> getFavoriteSongs();
  Future<Either<Failure, Stream<List<AudioItemEntity>>>> getFavoriteSongsStream();
}
