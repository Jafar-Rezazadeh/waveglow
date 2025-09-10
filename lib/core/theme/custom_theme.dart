import 'package:flutter/material.dart';
import 'package:waveglow/core/theme/color_palette.dart';

class CustomTheme {
  static ThemeData neonTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColorPalette().primary500,
      onPrimary: AppColorPalette().surface,
      secondary: AppColorPalette().neonPink,
      onSecondary: AppColorPalette().background,
      error: AppColorPalette().danger,
      onError: AppColorPalette().surface,
      surface: AppColorPalette().background,
      onSurface: AppColorPalette().surface,
    ),
    extensions: [AppColorPalette()],
  );
}
