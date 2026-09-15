import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1E1815),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4A373),
        onPrimary: Color(0xFF1E1815),
        secondary: Color(0xFFC86D51),
        onSecondary: Colors.white,
        surface: Color(0xFF28201B),
        onSurface: Color(0xFFF3E9DF),
        surfaceContainerHighest: Color(0xFF352B24),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1815),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFF3E9DF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF28201B),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      fontFamily: 'Roboto',
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFAF6F0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8C533E),
        onPrimary: Colors.white,
        secondary: Color(0xFFB57652),
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xFF2D2520),
        surfaceContainerHighest: Color(0xFFF0E8DD),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFAF6F0),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF2D2520),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      fontFamily: 'Roboto',
    );
  }
}
