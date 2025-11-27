import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';

class CustomDialogs {
  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

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
      buttonColor: _colorPalette.primary500,
      textConfirm: "بله",
      textCancel: "لغو",
      contentPadding: EdgeInsets.all(16),
      confirmTextColor: _colorPalette.surface,
      cancelTextColor: _colorPalette.surface,
      backgroundColor: _colorPalette.backgroundLow,
      onConfirm: () {
        onAccept();
        if (autoCloseDialog) {
          Get.back();
        }
      },
    );
  }
}
