import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';

class FailureWidget extends StatelessWidget {
  final Failure failure;

  const FailureWidget({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Text("error".tr), Text(failure.message), Text(failure.stackTrace.toString())],
      ),
    );
  }
}
