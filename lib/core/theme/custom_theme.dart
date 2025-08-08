import 'package:flutter/material.dart';
import 'package:waveglow/core/theme/color_palette.dart';

class CustomTheme {
  static ThemeData neonTheme = ThemeData(
    brightness: Brightness.dark,
    extensions: [neonPalette],
  );
}
