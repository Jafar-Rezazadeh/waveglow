import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class SaveTracksListDirectoryUC implements UseCase<void, TracksListDirectoryEntity> {
  final TracksListRepository _repository;

  SaveTracksListDirectoryUC({required TracksListRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(TracksListDirectoryEntity dir) {
    return _repository.saveDirectory(dir);
  }
}
