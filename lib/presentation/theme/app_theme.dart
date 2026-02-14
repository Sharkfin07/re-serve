import 'package:flutter/material.dart';
import './app_palette.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final scheme = ColorScheme.light(
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      surface: Colors.white,
      onPrimary: AppPalette.tertiaryLight,
      onSecondary: AppPalette.dark,
      onSurface: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: 'Outfit',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withValues(alpha: 0.08),
        labelStyle: TextStyle(color: scheme.onSurface),
        errorStyle: TextStyle(color: scheme.error),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) return scheme.error;
          if (states.contains(WidgetState.focused)) return scheme.primary;
          return scheme.onSurface;
        }),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) return scheme.error;
          if (states.contains(WidgetState.focused)) return scheme.primary;
          return scheme.onSurface;
        }),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final scheme = ColorScheme.dark(
      primary: AppPalette.primary,
      secondary: AppPalette.secondary,
      surface: AppPalette.dark,
      onPrimary: AppPalette.tertiaryLight,
      onSecondary: AppPalette.dark,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      fontFamily: 'Outfit',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface.withValues(alpha: 0.08),
        labelStyle: TextStyle(color: scheme.onSurface),
        errorStyle: TextStyle(color: scheme.error),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) return scheme.error;
          if (states.contains(WidgetState.focused)) return scheme.primary;
          return scheme.onSurface;
        }),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.error)) return scheme.error;
          if (states.contains(WidgetState.focused)) return scheme.primary;
          return scheme.onSurface;
        }),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
    );
  }
}
