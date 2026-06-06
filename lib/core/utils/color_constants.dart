import 'dart:ui';

class ExpressionColors {
  const ExpressionColors._();

  /// Vibrant palette — pops on both dark and light backgrounds.
  static const palette = [
    Color(0xFF4D9EFF), // Electric blue
    Color(0xFFFF4D8E), // Hot pink
    Color(0xFF3DEBA0), // Neon mint
    Color(0xFFFFAA4D), // Amber
    Color(0xFFB44DFF), // Electric purple
    Color(0xFF4DEEFF), // Cyan
    Color(0xFFFFE44D), // Gold
    Color(0xFFFF6B4D), // Coral
  ];

  static Color forIndex(int index) => palette[index % palette.length];
}
