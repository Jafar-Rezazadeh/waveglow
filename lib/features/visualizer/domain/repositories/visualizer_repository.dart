import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

abstract class VisualizerRepository {
  Future<Either<Failure, Stream<List<double>>>> getFrequenciesStream();
  Future<Either<Failure, Stream<VisualizerFrequencyBandsEntity>>> getFrequencyBandsStream();
}
