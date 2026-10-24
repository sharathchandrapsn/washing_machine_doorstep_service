import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class ShopColors {
  static const paper = Color(0xFFF6F4EF);
  static const ink = Color(0xFF1C2B33);
  static const accent = Color(0xFF0E7C7B);
}

abstract final class ShopLayout {
  static const desktopBreakpoint = 840.0;
  static const maxContentWidth = 1080.0;
}

ThemeData buildClearCycleTheme() {
  final heading = GoogleFonts.fraunces(
    color: ShopColors.ink,
    fontWeight: FontWeight.w600,
  );
  final body = GoogleFonts.sourceSans3(
    color: ShopColors.ink,
    fontWeight: FontWeight.w400,
  );

  final textTheme = TextTheme(
    displayLarge: heading.copyWith(fontSize: 56, height: 1.05),
    displayMedium: heading.copyWith(fontSize: 44, height: 1.08),
    displaySmall: heading.copyWith(fontSize: 36, height: 1.12),
    headlineLarge: heading.copyWith(fontSize: 32, height: 1.15),
    headlineMedium: heading.copyWith(fontSize: 26, height: 1.2),
    headlineSmall: heading.copyWith(fontSize: 22, height: 1.25),
    titleLarge: heading.copyWith(fontSize: 20, height: 1.3),
    titleMedium: body.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: body.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: body.copyWith(fontSize: 18, height: 1.5),
    bodyMedium: body.copyWith(fontSize: 16, height: 1.5),
    bodySmall: body.copyWith(fontSize: 14, height: 1.45),
    labelLarge: body.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    labelMedium: body.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    labelSmall: body.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
  );

  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: ShopColors.accent,
        brightness: Brightness.light,
      ).copyWith(
        primary: ShopColors.accent,
        onPrimary: ShopColors.paper,
        secondary: ShopColors.accent,
        onSecondary: ShopColors.paper,
        surface: ShopColors.paper,
        onSurface: ShopColors.ink,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.standard,
    scaffoldBackgroundColor: ShopColors.paper,
    colorScheme: colorScheme,
    textTheme: textTheme,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ShopColors.accent,
        foregroundColor: ShopColors.paper,
        textStyle: textTheme.labelLarge,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    ),
  );
}
