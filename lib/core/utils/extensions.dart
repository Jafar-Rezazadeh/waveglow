import 'package:flutter/material.dart';
import 'package:waveglow/core/core_exports.dart';

extension ColorPalette on BuildContext {
  AppColorPalette get palette => Theme.of(this).extension<AppColorPalette>()!;
}
