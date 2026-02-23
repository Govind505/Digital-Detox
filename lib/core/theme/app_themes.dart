import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData _base(ColorScheme scheme) => ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      );

  static final darkMinimal = _base(const ColorScheme.dark());
  static final matteNeon = _base(const ColorScheme.dark(
    primary: Color(0xFF39FF14),
    surface: Color(0xFF111111),
  ));
  static final softBlue = _base(ColorScheme.fromSeed(seedColor: Colors.blue));
  static final beigeMinimal = _base(const ColorScheme.light(
    primary: Color(0xFFA68A64),
    surface: Color(0xFFF4E9D8),
  ));
}
