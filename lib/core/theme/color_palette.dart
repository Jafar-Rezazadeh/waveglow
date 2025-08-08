import 'package:flutter/material.dart';

class AppColorPalette extends ThemeExtension<AppColorPalette> {
  final Color backGround;
  final Color primary;
  final Color accent;
  final Color accent2;
  final Color softPinkAccent;
  final Color textColor;

  AppColorPalette({
    required this.backGround,
    required this.primary,
    required this.accent,
    required this.accent2,
    required this.softPinkAccent,
    required this.textColor,
  });

  @override
  AppColorPalette copyWith({
    Color? backGround,
    Color? primary,
    Color? accent,
    Color? accent2,
    Color? softPinkAccent,
    Color? textColor,
  }) {
    return AppColorPalette(
      backGround: backGround ?? this.backGround,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      accent2: accent2 ?? this.accent2,
      softPinkAccent: softPinkAccent ?? this.softPinkAccent,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  AppColorPalette lerp(covariant ThemeExtension<AppColorPalette>? other, double t) {
    if (other is! AppColorPalette) return this;
    return AppColorPalette(
      backGround: Color.lerp(backGround, other.backGround, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      softPinkAccent: Color.lerp(softPinkAccent, other.softPinkAccent, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
    );
  }
}

final neonPalette = AppColorPalette(
  backGround: const Color(0xFF0b0b0c),
  primary: const Color(0xFF6b5cff),
  accent: const Color(0xFF00f0ff),
  accent2: const Color.fromARGB(255, 0, 118, 253),
  softPinkAccent: const Color.fromARGB(255, 255, 25, 156),
  textColor: const Color(0xFFfdfdfd),
);
