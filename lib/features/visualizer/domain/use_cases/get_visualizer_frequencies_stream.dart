import 'package:dartz/dartz.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class GetVisualizerFrequenciesStreamUC implements UseCase<Stream<List<double>>, NoParams> {
  final VisualizerRepository _repository;

  GetVisualizerFrequenciesStreamUC({required VisualizerRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Stream<List<double>>>> call(NoParams params) {
    return _repository.getFrequenciesStream();
  }
}
