import 'package:flutter/material.dart';

abstract class AppColors {
  static const accent = Colors.blueAccent;
  static const darkCard = Color(0xFF272C34);
}

abstract class _LightColors {
  static const background = Color(0xFFECF5F4);
  static const card = Colors.white;
}

abstract class _DarkColors {
  static const background = Color(0xFF1A1F25);
  static const card = AppColors.darkCard;
}

abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;
  static ThemeData light() => ThemeData(
      brightness: Brightness.light,
      accentColor: accentColor,
      visualDensity: visualDensity,
      backgroundColor: _LightColors.background,
      scaffoldBackgroundColor: _LightColors.background,
      cardColor: _LightColors.card,
      primaryTextTheme:
          const TextTheme(headline6: TextStyle(color: Colors.black)),
      iconTheme: const IconThemeData(color: Colors.black));

  static ThemeData dark() => ThemeData(
      brightness: Brightness.dark,
      accentColor: accentColor,
      visualDensity: visualDensity,
      backgroundColor: _DarkColors.background,
      scaffoldBackgroundColor: _DarkColors.background,
      cardColor: _DarkColors.card,
      primaryTextTheme:
          const TextTheme(headline6: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white));
}
