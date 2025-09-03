import 'package:dartz/dartz.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

abstract class VisualizerRepository {
  Future<Either<Failure, Stream<List<double>>>> getOutPutAudioStream();
  Future<Either<Failure, Stream<VisualizerBandsEntity>>> getPerceptualBandsStream();
}
