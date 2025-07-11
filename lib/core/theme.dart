import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tema claro principal da aplicação
final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: Colors.white,
    onPrimary: AppColors.buttonText,
    onSecondary: Colors.white,
    onBackground: AppColors.darkText,
    onSurface: AppColors.darkText,
    error: AppColors.warning,
    onError: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.buttonText,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.buttonText),
    titleTextStyle: TextStyle(
      color: AppColors.buttonText,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonBackground,
      foregroundColor: AppColors.buttonText,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFEEF8DA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.inputBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.inputBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.secondary),
    hintStyle: TextStyle(color: AppColors.textSecondary),
  ),
  iconTheme: IconThemeData(color: AppColors.icon),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.buttonText,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.secondary,
    contentTextStyle: TextStyle(color: AppColors.buttonText),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: AppColors.primary,
  ),
  dividerColor: AppColors.accent.withOpacity(0.2),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
  ),
); 