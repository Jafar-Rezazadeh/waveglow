import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';

class CustomDialogs {
  Future<void> showFailure(Failure failure) async {
    await Get.dialog(FailureWidget(failure: failure));
  }
}
