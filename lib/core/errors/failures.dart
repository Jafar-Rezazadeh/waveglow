import 'package:logger/logger.dart';

abstract class Failure {
  final String title;
  final StackTrace stackTrace;
  final String message;

  Failure({required this.title, required this.stackTrace, required this.message});
}

class InternalFailure extends Failure {
  InternalFailure({
    required super.title,
    required super.stackTrace,
    required super.message,
  });
}

class FailureFactory {
  Failure createFailure(dynamic e, StackTrace s) {
    Logger().e(e);
    return InternalFailure(title: "InternalFailure", stackTrace: s, message: e.toString());
  }
}
