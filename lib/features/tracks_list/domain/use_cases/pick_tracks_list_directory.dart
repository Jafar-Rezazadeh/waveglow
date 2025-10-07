import 'package:dartz/dartz.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class PickTracksListDirectoryUC implements UseCase<TracksListDirectoryEntity?, NoParams> {
  final TracksListRepository _repository;

  PickTracksListDirectoryUC({required TracksListRepository repository}) : _repository = repository;
  @override
  Future<Either<Failure, TracksListDirectoryEntity?>> call(NoParams params) {
    return _repository.pickDirectory();
  }
}
