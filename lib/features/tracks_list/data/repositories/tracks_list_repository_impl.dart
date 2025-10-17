import 'package:dartz/dartz.dart';
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
  Future<Either<Failure, TracksListDirectoryEntity?>> pickDirectory() async {
    try {
      final result = await _dataSource.pickDirectory();
      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> saveDirectory(TracksListDirectoryEntity dir) async {
    try {
      final result = await _dataSource.saveDirectory(dir);

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, List<TracksListDirectoryEntity>>> getDirectories() async {
    try {
      final result = await _dataSource.getDirectories();

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }
}
