import 'package:flutter/material.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/theme/color_palette.dart';

class CustomTheme {
  final _colorPalette = AppColorPalette();

  ThemeData neonTheme() => ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Vazirmatn",
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: _colorPalette.primary500,
      onPrimary: _colorPalette.surface,
      secondary: _colorPalette.neonPink,
      onSecondary: _colorPalette.background,
      error: _colorPalette.danger,
      onError: _colorPalette.surface,
      surface: _colorPalette.background,
      onSurface: _colorPalette.surface,
    ),
    sliderTheme: SliderThemeData(
      thumbShape: const RoundSliderThumbShape(disabledThumbRadius: 0),
      overlayColor: _colorPalette.primary500,
      inactiveTrackColor: _colorPalette.backgroundLow,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
    ),
    dropdownMenuTheme: _dropDownMenuTheme(),
    extensions: [_colorPalette],
  );

  DropdownMenuThemeData _dropDownMenuTheme() {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: _colorPalette.neutral700),
      borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
    );
    return DropdownMenuThemeData(
      menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll(_colorPalette.backgroundLow)),
      inputDecorationTheme: InputDecorationTheme(
        border: border,
        enabledBorder: border.copyWith(borderSide: BorderSide(color: _colorPalette.neutral600)),
        hintStyle: TextStyle(color: _colorPalette.neutral300),
      ),
    );
  }
}
