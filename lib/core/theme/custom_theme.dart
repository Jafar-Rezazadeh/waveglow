import 'package:flutter/material.dart';
import 'package:waveglow/core/core_exports.dart';

class CustomTheme {
  final _darkPalette = AppColorPalette(
    primary500: const Color(0xFF3464FC),
    primary600: const Color(0xFF264ED6),
    primary700: const Color(0xFF1A39A8),
    primary800: const Color(0xFF102379),
    primary900: const Color(0xFF0A154D),
    neonPink: const Color(0xFFEF0AE4),
    hotMagenta: const Color(0xFFFF1B6B),
    neonPurple: const Color(0xFFB026FF),
    electricBlue: const Color(0xFF00FFFF),
    background: const Color(0xFF0A0D14),
    backgroundLow: const Color(0xFF12141C),
    surface: const Color(0xFFFAFAFA),
    success: const Color(0xFF00FFAA),
    warning: const Color(0xFFFFC107),
    danger: const Color(0xFFFF1744),
    neutral50: const Color(0xFFF5F5F5),
    neutral100: const Color(0xFFE5E5E5),
    neutral200: const Color(0xFFD4D4D4),
    neutral300: const Color(0xFFA3A3A3),
    neutral400: const Color(0xFF737373),
    neutral500: const Color(0xFF646464),
    neutral600: const Color(0xFF464646),
    neutral700: const Color(0xFF292929),
    neutral800: const Color(0xFF3F3F3F),
    neutral900: const Color(0xFF2D2D2D),
  );

  final _lightPalette = AppColorPalette(
    primary500: const Color(0xFF0078D4), // Windows blue
    primary600: const Color(0xFF006CBE),
    primary700: const Color(0xFF005A9E),
    primary800: const Color(0xFF004578),
    primary900: const Color(0xFF00335A),

    neonPink: const Color(0xFFFF1F84),
    hotMagenta: const Color(0xFFB4009E),
    neonPurple: const Color(0xFF886CE4),
    electricBlue: const Color(0xFF00BCF2),

    // Windows 11 Light base colors
    background: const Color(0xFFF3F3F3), // background
    backgroundLow: const Color(0xFFFFFFFF), // white surfaces
    surface: const Color(0xFFF9F9F9), // white surfaces

    success: const Color(0xFF107C10),
    warning: const Color(0xFFFCE100),
    danger: const Color(0xFFD13438),

    neutral50: const Color(0xFFF9F9F9),
    neutral100: const Color(0xFFF3F3F3),
    neutral200: const Color(0xFFE5E5E5),
    neutral300: const Color(0xFFD0D0D0),
    neutral400: const Color(0xFFBFBFBF),
    neutral500: const Color(0xFF8A8A8A),
    neutral600: const Color(0xFF707070),
    neutral700: const Color(0xFF5A5A5A),
    neutral800: const Color(0xFF3F3F3F),
    neutral900: const Color(0xFF2D2D2D),
  );

  ThemeData darkTheme() => _buildTheme(brightness: Brightness.dark, palette: _darkPalette);

  ThemeData lightTheme() => _buildTheme(brightness: Brightness.light, palette: _lightPalette);

  ThemeData _buildTheme({required Brightness brightness, required AppColorPalette palette}) {
    final isDarkMode = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      fontFamily: "Vazirmatn",
      colorScheme: _colorSchema(palette, brightness),
      sliderTheme: _sliderThemeData(palette, brightness),
      dropdownMenuTheme: _dropDownMenuTheme(palette, isDarkMode),
      extensions: [palette],
    );
  }

  ColorScheme _colorSchema(AppColorPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,

      // Brand color
      primary: palette.primary500,
      onPrimary: isDark ? palette.surface : palette.background,

      // Accent color
      secondary: palette.electricBlue,
      onSecondary: isDark ? palette.surface : palette.background,

      // Tertiary (fun accent) – using your neonPink
      tertiary: palette.neonPink,
      onTertiary: isDark ? palette.surface : palette.background,

      // Error colors
      error: palette.danger,
      onError: isDark ? palette.surface : palette.background,

      // Surface colors
      surface: isDark ? palette.background : palette.surface,
      onSurface: isDark ? palette.surface : palette.neutral900,

      // Surface variants (for cards, sheets, etc.)
      surfaceContainerHighest: isDark ? palette.neutral700 : palette.neutral200,
      onSurfaceVariant: isDark ? palette.neutral100 : palette.neutral700,

      // Outline
      outline: isDark ? palette.neutral500 : palette.neutral400,

      // Inverse colors
      inverseSurface: isDark ? palette.surface : palette.background,
      onInverseSurface: isDark ? palette.neutral900 : palette.surface,
      inversePrimary: palette.primary600,

      // Shadow/elevation
      shadow: Colors.black,
      scrim: Colors.black54,
    );
  }

  SliderThemeData _sliderThemeData(AppColorPalette palette, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SliderThemeData(
      thumbShape: const RoundSliderThumbShape(disabledThumbRadius: 0),
      overlayColor: palette.primary500,
      inactiveTrackColor: isDark ? palette.neutral800 : palette.neutral200,
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
    );
  }

  DropdownMenuThemeData _dropDownMenuTheme(AppColorPalette palette, bool isDarkMode) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: palette.neutral700),
      borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
    );
    return DropdownMenuThemeData(
      menuStyle: MenuStyle(backgroundColor: WidgetStatePropertyAll(palette.backgroundLow)),
      inputDecorationTheme: InputDecorationTheme(
        border: border,
        enabledBorder: border.copyWith(
          borderSide: BorderSide(color: isDarkMode ? palette.neutral600 : palette.neutral200),
        ),
        hintStyle: TextStyle(color: palette.neutral300),
      ),
    );
  }
}
