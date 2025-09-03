import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

class VisualizerRepositoryImpl implements VisualizerRepository {
  final VisualizerPlatformDataSource _platformDataSource;
  final FailureFactory _failureFactory;

  VisualizerRepositoryImpl({
    required VisualizerPlatformDataSource platformDataSource,
    required FailureFactory failureFactory,
  })  : _platformDataSource = platformDataSource,
        _failureFactory = failureFactory;

  @override
  Future<Either<Failure, Stream<List<double>>>> getOutPutAudioStream() async {
    try {
      final result = await _platformDataSource.getOutPutAudioStream();

      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }

  @override
  Future<Either<Failure, Stream<VisualizerBandsModel>>> getPerceptualBandsStream() async {
    try {
      final result = await _platformDataSource.getPerceptualBandsStream();
      return right(result);
    } catch (e, s) {
      return left(_failureFactory.createFailure(e, s));
    }
  }
}
