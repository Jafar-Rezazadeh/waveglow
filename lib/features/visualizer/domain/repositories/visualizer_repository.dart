import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';

abstract class VisualizerRepository {
  Future<Either<Failure, Stream<List<double>>>> getOutPutAudioStream();
}
