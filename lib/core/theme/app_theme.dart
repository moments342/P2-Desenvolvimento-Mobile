import 'package:flutter/material.dart';

class AppTheme {
  static const Color corPrimaria = Color(0xFF1565C0);

  static ThemeData get temaClaro {
    final esquema = ColorScheme.fromSeed(
      seedColor: corPrimaria,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      appBarTheme: AppBarTheme(
        backgroundColor: esquema.primary,
        foregroundColor: esquema.onPrimary,
        centerTitle: true,
      ),
    );
  }
}
