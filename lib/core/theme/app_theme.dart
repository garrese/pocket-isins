import 'package:flutter/material.dart';
import 'app_theme_extension.dart';

// White-grey 0xFFE2E8F0
// Purple light 0xFFA5B4FC
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      extensions: const [
        AppThemeExtension(
          mainTitleColor: Color(0xFFFFFFFF),
          subtitleColor: Color(0xFF90CAF9),
        ),
      ],
      colorScheme: const ColorScheme.dark(
        primary: Colors.tealAccent,
        secondary: Colors.amberAccent,
        surface: Color(0xFF1E1E2C),
      ),
      scaffoldBackgroundColor: const Color(0xFF12121D),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E2C),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E2C),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
