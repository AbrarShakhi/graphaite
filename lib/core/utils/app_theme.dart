import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const _lightSeed = Color(0xFF2D6ACC);
  static const _darkSeed = Color(0xFF7C6AF5);

  static ThemeData light() => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _lightSeed),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'sans-serif',
      );

  static ThemeData dark() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D0D14),
        fontFamily: 'sans-serif',
      );
}
