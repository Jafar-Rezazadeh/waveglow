import 'package:dartz/dartz.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

class GetVisualizerPerceptualBandsStreamUC
    implements UseCase<Stream<VisualizerBandsEntity>, NoParams> {
  final VisualizerRepository _repository;

  GetVisualizerPerceptualBandsStreamUC({required VisualizerRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Stream<VisualizerBandsEntity>>> call(NoParams params) {
    return _repository.getPerceptualBandsStream();
  }
}
