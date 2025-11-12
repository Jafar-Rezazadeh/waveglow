import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListRepository {
  Future<Either<Failure, TracksListDirectoryEntity?>> pickDirectory(SortType sortType);
  Future<Either<Failure, void>> saveDirectory(TracksListDirectoryEntity dir);
  Future<Either<Failure, List<TracksListDirectoryEntity>>> getDirectories(SortType sortType);
  Future<Either<Failure, void>> deleteDir(String id);
  Future<Either<Failure, bool>> isDirectoryExists(String dirPath);

  Future<Either<Failure, void>> syncAudios();
}
