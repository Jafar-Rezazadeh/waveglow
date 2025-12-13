import 'package:dartz/dartz.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/domain/repositories/tracks_list_repository.dart';

class DeleteTracksListDirectoryUC implements UseCase<void, String> {
  final TracksListRepository _repository;

  DeleteTracksListDirectoryUC({required TracksListRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteDir(id);
  }
}
