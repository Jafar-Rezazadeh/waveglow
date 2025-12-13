import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';

class CustomDialogs {
  Future<void> showFailure(Failure failure) async {
    await Get.dialog(FailureWidget(failure: failure));
  }

  Future<void> showAreYouSure({
    required String title,
    required String content,
    required VoidCallback onAccept,
    bool autoCloseDialog = true,
  }) async {
    await Get.defaultDialog(
      onCancel: () => Get.back(),
      title: title,
      content: Text(content),
      buttonColor: Get.context?.palette.primary500,
      textConfirm: "yes".tr,
      textCancel: "cancel".tr,
      contentPadding: EdgeInsets.all(16),
      confirmTextColor: Get.context?.palette.surface,
      cancelTextColor: Get.isDarkMode
          ? Get.context?.palette.surface
          : Get.context?.palette.neutral700,
      backgroundColor: Get.context?.palette.backgroundLow,
      onConfirm: () {
        onAccept();
        if (autoCloseDialog) {
          Get.back();
        }
      },
    );
  }
}
