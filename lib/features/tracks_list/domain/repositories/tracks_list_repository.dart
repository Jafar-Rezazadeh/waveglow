import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

abstract class TracksListRepository {
  Future<Either<Failure, TracksListDirectoryEntity?>> pickDirectory();
}
