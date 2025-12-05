import 'package:flutter/material.dart';
import 'package:waveglow/core/core_exports.dart';

// TODO: use this in all widget tree instead of Get.theme.extension<AppColorPalette>() for smooth transition between themes
extension ColorPalette on BuildContext {
  AppColorPalette get palette => Theme.of(this).extension<AppColorPalette>()!;
}
