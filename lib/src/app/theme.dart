import 'package:flutter/material.dart';

enum AppFontSize { small, medium, large }

extension AppFontSizeX on AppFontSize {
  String get label {
    switch (this) {
      case AppFontSize.small:
        return 'சிறியது';
      case AppFontSize.medium:
        return 'நடுத்தரம்';
      case AppFontSize.large:
        return 'பெரியது';
    }
  }

  double get scale {
    switch (this) {
      case AppFontSize.small:
        return 0.92;
      case AppFontSize.medium:
        return 1.0;
      case AppFontSize.large:
        return 1.14;
    }
  }

  static AppFontSize fromStorage(String? value) {
    switch (value) {
      case 'small':
        return AppFontSize.small;
      case 'large':
        return AppFontSize.large;
      default:
        return AppFontSize.medium;
    }
  }

  String get storageValue => name;
}

class AppTheme {
  AppTheme._();

  // Palette: black · blue · sky blue · grey
  static const Color _black = Color(0xFF0B1220);
  static const Color _blue = Color(0xFF1565C0);
  static const Color _skyBlue = Color(0xFF4FC3F7);
  static const Color _grey = Color(0xFF607080);
  static const Color _surfaceLight = Color(0xFFF2F5F8);
  static const Color _surfaceDark = Color(0xFF0B1220);
  static const Color _cardLight = Color(0xFFFFFFFF);
  static const Color _cardDark = Color(0xFF152033);

  static ThemeData light(AppFontSize fontSize) =>
      _build(Brightness.light, fontSize);

  static ThemeData dark(AppFontSize fontSize) =>
      _build(Brightness.dark, fontSize);

  static ColorScheme _scheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ColorScheme(
      brightness: brightness,
      primary: isDark ? _skyBlue : _blue,
      onPrimary: isDark ? _black : Colors.white,
      primaryContainer: isDark ? const Color(0xFF123A5C) : const Color(0xFFD6EEFF),
      onPrimaryContainer: isDark ? _skyBlue : const Color(0xFF0A3A66),
      secondary: isDark ? const Color(0xFF90CAF9) : _skyBlue,
      onSecondary: _black,
      secondaryContainer: isDark ? const Color(0xFF1A3348) : const Color(0xFFE3F5FC),
      onSecondaryContainer: isDark ? _skyBlue : const Color(0xFF0D47A1),
      tertiary: _grey,
      onTertiary: Colors.white,
      tertiaryContainer: isDark ? const Color(0xFF2A3440) : const Color(0xFFE8EDF2),
      onTertiaryContainer: isDark ? const Color(0xFFCFD8DC) : const Color(0xFF37474F),
      error: const Color(0xFFCF6679),
      onError: _black,
      surface: isDark ? _surfaceDark : _surfaceLight,
      onSurface: isDark ? const Color(0xFFE6EEF5) : _black,
      onSurfaceVariant: isDark ? const Color(0xFFA8B6C4) : _grey,
      outline: isDark ? const Color(0xFF4A5A6A) : const Color(0xFF90A0B0),
      outlineVariant: isDark ? const Color(0xFF2A3748) : const Color(0xFFD0D8E0),
      surfaceContainerLowest: isDark ? _cardDark : _cardLight,
      surfaceContainerHighest: isDark ? const Color(0xFF1C2A3C) : const Color(0xFFE4EAF0),
      inverseSurface: isDark ? _surfaceLight : _black,
      onInverseSurface: isDark ? _black : Colors.white,
      inversePrimary: isDark ? _blue : _skyBlue,
      shadow: Colors.black,
      scrim: Colors.black,
    );
  }

  static ThemeData _build(Brightness brightness, AppFontSize fontSize) {
    final isDark = brightness == Brightness.dark;
    final scheme = _scheme(brightness);

    final textTheme = _scaleTextTheme(
      TextTheme(
          displayLarge: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: scheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            height: 1.55,
            color: scheme.onSurface,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: scheme.onSurface.withValues(alpha: 0.88),
          ),
          bodySmall: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
      ),
      fontSize.scale,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: isDark ? _cardDark : _cardLight,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        indicatorColor: scheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.55 : 0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }

  static TextTheme _scaleTextTheme(TextTheme theme, double scale) {
    TextStyle? scaleStyle(TextStyle? style) {
      if (style == null || style.fontSize == null) return style;
      return style.copyWith(fontSize: style.fontSize! * scale);
    }

    return TextTheme(
      displayLarge: scaleStyle(theme.displayLarge),
      displayMedium: scaleStyle(theme.displayMedium),
      displaySmall: scaleStyle(theme.displaySmall),
      headlineLarge: scaleStyle(theme.headlineLarge),
      headlineMedium: scaleStyle(theme.headlineMedium),
      headlineSmall: scaleStyle(theme.headlineSmall),
      titleLarge: scaleStyle(theme.titleLarge),
      titleMedium: scaleStyle(theme.titleMedium),
      titleSmall: scaleStyle(theme.titleSmall),
      bodyLarge: scaleStyle(theme.bodyLarge),
      bodyMedium: scaleStyle(theme.bodyMedium),
      bodySmall: scaleStyle(theme.bodySmall),
      labelLarge: scaleStyle(theme.labelLarge),
      labelMedium: scaleStyle(theme.labelMedium),
      labelSmall: scaleStyle(theme.labelSmall),
    );
  }
}
