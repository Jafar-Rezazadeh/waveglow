import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class IsTracksListDirectoryExistsUC implements UseCase<bool, String> {
  final TracksListRepository _repository;

  IsTracksListDirectoryExistsUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(String dirPath) {
    return _repository.isDirectoryExists(dirPath);
  }
}
