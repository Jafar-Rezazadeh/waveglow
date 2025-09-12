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
    sliderTheme: SliderThemeData(
      thumbShape: const RoundSliderThumbShape(
        disabledThumbRadius: 0,
        enabledThumbRadius: 0,
      ),
      overlayColor: AppColorPalette().primary500,
      inactiveTrackColor: AppColorPalette().backgroundLow,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
    ),
    extensions: [AppColorPalette()],
  );
}
