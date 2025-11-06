import 'package:dartz/dartz.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListRepositoryImpl implements TracksListRepository {
  final TracksListDataSource _dataSource;
  final FailureFactory _failureFactory;

  TracksListRepositoryImpl({
    required TracksListDataSource dataSource,
    required FailureFactory failureFactory,
  }) : _dataSource = dataSource,
       _failureFactory = failureFactory;

  @override
  Future<Either<Failure, TracksListDirectoryEntity?>> pickDirectory(SortType sortType) async {
    try {
      final result = await _dataSource.pickDirectory(sortType);
      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> saveDirectory(TracksListDirectoryEntity dir) async {
    try {
      final result = await _dataSource.saveDirectory(TracksListDirectoryModel.fromEntity(dir));

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, List<TracksListDirectoryEntity>>> getDirectories(SortType sortType) async {
    try {
      final result = await _dataSource.getDirectories(sortType);

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDir(String id) async {
    try {
      final result = await _dataSource.deleteDir(id);

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, bool>> isDirectoryExists(String dirPath) async {
    try {
      final result = await _dataSource.isDirectoryExists(dirPath);

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }
}
