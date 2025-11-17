import 'package:flutter/material.dart';

class AppTheme {
  // Cores oficiais da paleta B (Esportivo Automotivo)
  static const Color primaryColor = Color(0xFFD32F2F); // Vermelho Sport
  static const Color secondaryColor = Color(0xFF212121); // Preto grafite
  static const Color tertiaryColor = Color(0xFFFFC107); // Ambar (destaques)
  static const Color surfaceColor = Color(0xFFF5F5F5); // Cinza claro
  static const Color errorColor = Color(0xFFB71C1C); // Vermelho escuro

  static ThemeData get temaClaro {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: surfaceColor,
      onBackground: Colors.black87,
      surface: surfaceColor,
      onSurface: Colors.black87,
      tertiary: tertiaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Estilo da AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Botões flutuantes (FAB)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiaryColor,
        foregroundColor: Colors.black,
        elevation: 4,
      ),

      // Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: Colors.grey[700]),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Drawer estilizado
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFF3F3F3)),

      // Icones padrão
      iconTheme: const IconThemeData(color: secondaryColor, size: 26),

      scaffoldBackgroundColor: surfaceColor,
    );
  }
}
