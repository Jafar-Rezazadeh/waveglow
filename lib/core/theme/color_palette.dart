import 'package:flutter/material.dart';

class AppColorPalette extends ThemeExtension<AppColorPalette> {
  // Primary (Heavy Blue scale)
  final Color primary500; // Main Primary
  final Color primary600;
  final Color primary700;
  final Color primary800;
  final Color primary900;

  // Secondary (Neons & Brand accents)
  final Color neonPink;
  final Color hotMagenta;
  final Color neonPurple;
  final Color electricBlue;

  // Backgrounds
  final Color background;
  final Color backgroundLow;
  final Color surface;

  // Functional accents
  final Color success;
  final Color warning;
  final Color danger;

  // Text
  final Color neutral50;
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;

  AppColorPalette({
    required this.primary500,
    required this.primary600,
    required this.primary700,
    required this.primary800,
    required this.primary900,
    required this.neonPink,
    required this.hotMagenta,
    required this.neonPurple,
    required this.electricBlue,
    required this.background,
    required this.backgroundLow,
    required this.surface,
    required this.success,
    required this.warning,
    required this.danger,
    required this.neutral50,
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900,
  });

  @override
  AppColorPalette copyWith({
    Color? primary500,
    Color? primary600,
    Color? primary700,
    Color? primary800,
    Color? primary900,
    Color? neonPink,
    Color? hotMagenta,
    Color? neonPurple,
    Color? electricBlue,
    Color? background,
    Color? backgroundLow,
    Color? surface,
    Color? success,
    Color? warning,
    Color? danger,
    Color? neutral50,
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? neutral900,
  }) {
    return AppColorPalette(
      primary500: primary500 ?? this.primary500,
      primary600: primary600 ?? this.primary600,
      primary700: primary700 ?? this.primary700,
      primary800: primary800 ?? this.primary800,
      primary900: primary900 ?? this.primary900,
      neonPink: neonPink ?? this.neonPink,
      hotMagenta: hotMagenta ?? this.hotMagenta,
      neonPurple: neonPurple ?? this.neonPurple,
      electricBlue: electricBlue ?? this.electricBlue,
      background: background ?? this.background,
      backgroundLow: backgroundLow ?? this.backgroundLow,
      surface: surface ?? this.surface,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      neutral50: neutral50 ?? this.neutral50,
      neutral100: neutral100 ?? this.neutral100,
      neutral200: neutral200 ?? this.neutral200,
      neutral300: neutral300 ?? this.neutral300,
      neutral400: neutral400 ?? this.neutral400,
      neutral500: neutral500 ?? this.neutral500,
      neutral600: neutral600 ?? this.neutral600,
      neutral700: neutral700 ?? this.neutral700,
      neutral800: neutral800 ?? this.neutral800,
      neutral900: neutral900 ?? this.neutral900,
    );
  }

  @override
  AppColorPalette lerp(ThemeExtension<AppColorPalette>? other, double t) {
    if (other is! AppColorPalette) return this;

    Color lerp(Color a, Color b) => Color.lerp(a, b, t)!;

    return AppColorPalette(
      primary500: lerp(primary500, other.primary500),
      primary600: lerp(primary600, other.primary600),
      primary700: lerp(primary700, other.primary700),
      primary800: lerp(primary800, other.primary800),
      primary900: lerp(primary900, other.primary900),
      neonPink: lerp(neonPink, other.neonPink),
      hotMagenta: lerp(hotMagenta, other.hotMagenta),
      neonPurple: lerp(neonPurple, other.neonPurple),
      electricBlue: lerp(electricBlue, other.electricBlue),
      background: lerp(background, other.background),
      backgroundLow: lerp(backgroundLow, other.backgroundLow),
      surface: lerp(surface, other.surface),
      success: lerp(success, other.success),
      warning: lerp(warning, other.warning),
      danger: lerp(danger, other.danger),
      neutral50: lerp(neutral50, other.neutral50),
      neutral100: lerp(neutral100, other.neutral100),
      neutral200: lerp(neutral200, other.neutral200),
      neutral300: lerp(neutral300, other.neutral300),
      neutral400: lerp(neutral400, other.neutral400),
      neutral500: lerp(neutral500, other.neutral500),
      neutral600: lerp(neutral600, other.neutral600),
      neutral700: lerp(neutral700, other.neutral700),
      neutral800: lerp(neutral800, other.neutral800),
      neutral900: lerp(neutral900, other.neutral900),
    );
  }
}
