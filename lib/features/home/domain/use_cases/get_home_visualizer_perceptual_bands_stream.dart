import 'package:dartz/dartz.dart';
import 'package:waveglow/core/contracts/use_case.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

class GetHomeVisualizerPerceptualBandsStreamUC
    implements UseCase<Stream<HomeVisualizerBandsEntity>, NoParams> {
  final HomeVisualizerRepository _repository;

  GetHomeVisualizerPerceptualBandsStreamUC({required HomeVisualizerRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Stream<HomeVisualizerBandsEntity>>> call(NoParams params) {
    return _repository.getPerceptualBandsStream();
  }
}
