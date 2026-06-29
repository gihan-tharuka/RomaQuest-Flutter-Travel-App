import 'package:flutter/material.dart';
import 'package:romaquest/theme/app_tokens.dart';

ThemeData buildAppTheme({
  required Brightness brightness,
}) {
  final isDark = brightness == Brightness.dark;

  const lightCanvas = Color(0xFFF7F1E8);
  const lightSurface = Color(0xFFFFFCF7);
  const lightSurfaceAlt = Color(0xFFF1E6D7);
  const lightAccent = Color(0xFFB86A4C);
  const lightText = Color(0xFF1F1A17);
  const lightMuted = Color(0xFF7A6B61);
  const lightBorder = Color(0xFFD9C8B7);

  const darkCanvas = Color(0xFF161311);
  const darkSurface = Color(0xFF211C18);
  const darkSurfaceAlt = Color(0xFF2B241F);
  const darkAccent = Color(0xFFD19573);
  const darkText = Color(0xFFF6EFE8);
  const darkMuted = Color(0xFFB9A89B);
  const darkBorder = Color(0xFF473A31);

  final canvas = isDark ? darkCanvas : lightCanvas;
  final surface = isDark ? darkSurface : lightSurface;
  final surfaceAlt = isDark ? darkSurfaceAlt : lightSurfaceAlt;
  final accent = isDark ? darkAccent : lightAccent;
  final text = isDark ? darkText : lightText;
  final muted = isDark ? darkMuted : lightMuted;
  final border = isDark ? darkBorder : lightBorder;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: surfaceAlt,
    onPrimary: text,
    secondary: accent,
    onSecondary: Colors.white,
    error: const Color(0xFFB84D4D),
    onError: Colors.white,
    surface: surface,
    onSurface: text,
  );

  final baseTextTheme = ThemeData(
    brightness: brightness,
    useMaterial3: true,
  ).textTheme;

  final textTheme = baseTextTheme.copyWith(
    displaySmall: baseTextTheme.displaySmall?.copyWith(
      color: text,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(
      color: text,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    titleLarge: baseTextTheme.titleLarge?.copyWith(
      color: text,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
    titleMedium: baseTextTheme.titleMedium?.copyWith(
      color: text,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(
      color: text,
      height: 1.4,
      letterSpacing: 0,
    ),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(
      color: text,
      height: 1.4,
      letterSpacing: 0,
    ),
    bodySmall: baseTextTheme.bodySmall?.copyWith(
      color: muted,
      height: 1.35,
      letterSpacing: 0,
    ),
    labelLarge: baseTextTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
  );

  return ThemeData(
    brightness: brightness,
    useMaterial3: true,
    scaffoldBackgroundColor: canvas,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: text,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.card,
        side: BorderSide(color: border),
      ),
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.28 : 0.08),
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.card,
      ),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      labelStyle: textTheme.bodyMedium?.copyWith(color: muted),
      hintStyle: textTheme.bodyMedium?.copyWith(color: muted),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: const BorderSide(color: Color(0xFFB84D4D)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorders.input,
        borderSide: const BorderSide(color: Color(0xFFB84D4D), width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.pill,
        ),
        textStyle: textTheme.labelLarge,
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: text,
        textStyle: textTheme.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceAlt,
      selectedColor: accent,
      disabledColor: border,
      secondarySelectedColor: accent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      labelStyle: textTheme.bodySmall?.copyWith(color: text),
      secondaryLabelStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.pill,
        side: BorderSide(color: border),
      ),
      brightness: brightness,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: accent,
      unselectedItemColor: muted,
      selectedLabelStyle: textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: textTheme.bodySmall,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerColor: border,
    splashColor: accent.withValues(alpha: 0.12),
    highlightColor: accent.withValues(alpha: 0.08),
  );
}
