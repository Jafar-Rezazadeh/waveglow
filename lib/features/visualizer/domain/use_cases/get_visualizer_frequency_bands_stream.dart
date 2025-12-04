import 'package:dartz/dartz.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class GetVisualizerFrequencyBandsStreamUC
    implements UseCase<Stream<VisualizerFrequencyBandsEntity>, NoParams> {
  final VisualizerRepository _repository;

  GetVisualizerFrequencyBandsStreamUC({required VisualizerRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, Stream<VisualizerFrequencyBandsEntity>>> call(NoParams params) {
    return _repository.getFrequencyBandsStream();
  }
}
