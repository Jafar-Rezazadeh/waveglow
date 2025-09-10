import 'package:flutter/material.dart';

class AppColorPalette extends ThemeExtension<AppColorPalette> {
  // Primary (Heavy Blue scale)
  final Color primary500 = const Color(0xFF3464FC); // Main Primary
  final Color primary600 = const Color(0xFF264ED6);
  final Color primary700 = const Color(0xFF1A39A8);
  final Color primary800 = const Color(0xFF102379);
  final Color primary900 = const Color(0xFF0A154D);

  // Secondary (Neons & Brand accents)
  final Color neonPink = const Color(0xFFEF0AE4);
  final Color hotMagenta = const Color(0xFFFF1B6B);
  final Color neonPurple = const Color(0xFFB026FF);
  final Color electricBlue = const Color(0xFF00FFFF);

  // Backgrounds
  final Color background = const Color(0xFF0A0D14);
  final Color backgroundLow = const Color(0xFF12141C);
  final Color surface = const Color(0xFFFAFAFA);

  // Functional accents
  final Color success = const Color(0xFF00FFAA);
  final Color warning = const Color(0xFFFFC107);
  final Color danger = const Color(0xFFFF1744);

  // Text
  final Color neutral50 = const Color(0xFFF5F5F5);
  final Color neutral100 = const Color(0xFFE5E5E5);
  final Color neutral200 = const Color(0xFFD4D4D4);
  final Color neutral300 = const Color(0xFFA3A3A3);
  final Color neutral400 = const Color(0xFF737373);

  @override
  ThemeExtension<AppColorPalette> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppColorPalette> lerp(covariant ThemeExtension<AppColorPalette>? other, double t) {
    return this;
  }
}
