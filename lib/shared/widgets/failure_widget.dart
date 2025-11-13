import 'package:flutter/material.dart';
import 'package:waveglow/core/errors/failures.dart';

class FailureWidget extends StatelessWidget {
  final Failure failure;

  const FailureWidget({super.key, required this.failure});
  // TODO: improve the ui of the error

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("خطا"),
          Text(failure.message),
          Text(failure.stackTrace.toString()),
        ],
      ),
    );
  }
}
