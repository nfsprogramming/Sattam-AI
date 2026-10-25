import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────
// SattamColors — named color tokens resolved by theme
// ─────────────────────────────────────────────────────

class SattamColors {
  // Base
  final Color bgBase;
  final Color bgDeep;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceBright;

  // Brand
  final Color primary;
  final Color primaryContainer;
  final Color primaryFixed;
  final Color primaryFixedDim;

  // Secondary
  final Color secondary;
  final Color secondaryContainer;

  // Tertiary
  final Color tertiary;

  // Semantic
  final Color sosRed;
  final Color rtiCyan;
  final Color evidencePurple;

  // Text
  final Color textPrimary;
  final Color textOnSurface;
  final Color textOnSurfaceVariant;
  final Color textMuted;
  final Color textDisabled;

  // Borders
  final Color borderStrong;
  final Color borderSubtle;
  final Color outlineVariant;

  // Glass
  final Color glassPanel;

  const SattamColors({
    required this.bgBase,
    required this.bgDeep,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceBright,
    required this.primary,
    required this.primaryContainer,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.secondary,
    required this.secondaryContainer,
    required this.tertiary,
    required this.sosRed,
    required this.rtiCyan,
    required this.evidencePurple,
    required this.textPrimary,
    required this.textOnSurface,
    required this.textOnSurfaceVariant,
    required this.textMuted,
    required this.textDisabled,
    required this.borderStrong,
    required this.borderSubtle,
    required this.outlineVariant,
    required this.glassPanel,
  });

  // ──── Dark palette (Apple Pure Black) ────
  static const dark = SattamColors(
    bgBase: Color(0xFF000000),
    bgDeep: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    surfaceContainer: Color(0xFF2C2C2E),
    surfaceContainerHigh: Color(0xFF3A3A3C),
    surfaceContainerHighest: Color(0xFF48484A),
    surfaceBright: Color(0xFF2C2C2E),
    primary: Color(0xFF0A84FF),
    primaryContainer: Color(0xFF0A84FF),
    primaryFixed: Color(0xFF5E5CE6),
    primaryFixedDim: Color(0xFF0A84FF),
    secondary: Color(0xFFFF9F0A),
    secondaryContainer: Color(0xFFFF9F0A),
    tertiary: Color(0xFF32D74B),
    sosRed: Color(0xFFFF453A),
    rtiCyan: Color(0xFF64D2FF),
    evidencePurple: Color(0xFFBF5AF2),
    textPrimary: Color(0xFFFFFFFF),
    textOnSurface: Color(0xFFEBEBF5),
    textOnSurfaceVariant: Color(0xFFEBEBF5),
    textMuted: Color(0xFF8E8E93),
    textDisabled: Color(0xFF3A3A3C),
    borderStrong: Color(0xFF38383A),
    borderSubtle: Color(0xFF2C2C2E),
    outlineVariant: Color(0xFF38383A),
    glassPanel: Color(0x99000000),
  );

  // ──── Light palette (Apple-inspired light) ────
  static const light = SattamColors(
    bgBase: Color(0xFFF2F2F7),
    bgDeep: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFE5E5EA),
    surfaceContainerHigh: Color(0xFFD1D1D6),
    surfaceContainerHighest: Color(0xFFC7C7CC),
    surfaceBright: Color(0xFFFFFFFF),
    primary: Color(0xFF007AFF),
    primaryContainer: Color(0xFF007AFF),
    primaryFixed: Color(0xFF5E5CE6),
    primaryFixedDim: Color(0xFF007AFF),
    secondary: Color(0xFFFF9500),
    secondaryContainer: Color(0xFFFF9500),
    tertiary: Color(0xFF34C759),
    sosRed: Color(0xFFFF3B30),
    rtiCyan: Color(0xFF5AC8FA),
    evidencePurple: Color(0xFFAF52DE),
    textPrimary: Color(0xFF000000),
    textOnSurface: Color(0xFF1C1C1E),
    textOnSurfaceVariant: Color(0xFF3A3A3C),
    textMuted: Color(0xFF8E8E93),
    textDisabled: Color(0xFFC7C7CC),
    borderStrong: Color(0xFFC7C7CC),
    borderSubtle: Color(0xFFD1D1D6),
    outlineVariant: Color(0xFFC7C7CC),
    glassPanel: Color(0xCCFFFFFF),
  );
}

// ─────────────────────────────────────────────────────
// BuildContext extension — makes context.colors work
// ─────────────────────────────────────────────────────

extension SattamColorsExtension on BuildContext {
  SattamColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? SattamColors.dark
        : SattamColors.light;
  }
}

// ─────────────────────────────────────────────────────
// Legacy static accessors (for any remaining AppColors.* usage)
// ─────────────────────────────────────────────────────

class AppColors {
  // Base (Apple Pure Black & Greys)
  static const bgBase = Color(0xFF000000);
  static const bgDeep = Color(0xFF000000);
  static const surface = Color(0xFF1C1C1E);
  static const surfaceContainer = Color(0xFF2C2C2E);
  static const surfaceContainerHigh = Color(0xFF3A3A3C);
  static const surfaceContainerHighest = Color(0xFF48484A);
  static const surfaceBright = Color(0xFF2C2C2E);

  // Brand (Apple Blue)
  static const primary = Color(0xFF0A84FF);
  static const primaryContainer = Color(0xFF0A84FF);
  static const primaryFixed = Color(0xFF5E5CE6);
  static const primaryFixedDim = Color(0xFF0A84FF);

  // Secondary (Apple Orange)
  static const secondary = Color(0xFFFF9F0A);
  static const secondaryContainer = Color(0xFFFF9F0A);

  // Tertiary (Apple Green)
  static const tertiary = Color(0xFF32D74B);

  // Semantic
  static const sosRed = Color(0xFFFF453A);
  static const rtiCyan = Color(0xFF64D2FF);
  static const evidencePurple = Color(0xFFBF5AF2);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textOnSurface = Color(0xFFEBEBF5);
  static const textOnSurfaceVariant = Color(0xFFEBEBF5);
  static const textMuted = Color(0xFF8E8E93);
  static const textDisabled = Color(0xFF3A3A3C);

  // Borders
  static const borderStrong = Color(0xFF38383A);
  static const borderSubtle = Color(0xFF2C2C2E);
  static const outlineVariant = Color(0xFF38383A);

  // Glass
  static const glassPanel = Color(0x99000000); // Semi-transparent black
}

// ─────────────────────────────────────────────────────
// ThemeData factories
// ─────────────────────────────────────────────────────

class AppTheme {
  static ThemeData get darkTheme {
    final c = SattamColors.dark;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: c.bgBase,
      colorScheme: ColorScheme.dark(
        primary: c.primaryContainer,
        secondary: c.secondary,
        surface: c.surface,
      ),
      textTheme: GoogleFonts.playfairDisplayTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 40,
          height: 1.1,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.playfairDisplay(
          color: c.textOnSurface,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.playfairDisplay(
          color: c.textOnSurface,
          fontSize: 14,
          height: 1.6,
        ),
        bodySmall: GoogleFonts.playfairDisplay(
          color: c.textMuted,
          fontSize: 13,
          height: 1.5,
        ),
        labelSmall: GoogleFonts.playfairDisplay(
          color: c.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final c = SattamColors.light;
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: c.bgBase,
      colorScheme: ColorScheme.light(
        primary: c.primaryContainer,
        secondary: c.secondary,
        surface: c.surface,
      ),
      textTheme: GoogleFonts.playfairDisplayTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 40,
          height: 1.1,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: c.textPrimary,
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.playfairDisplay(
          color: c.textOnSurface,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.playfairDisplay(
          color: c.textOnSurface,
          fontSize: 14,
          height: 1.6,
        ),
        bodySmall: GoogleFonts.playfairDisplay(
          color: c.textMuted,
          fontSize: 13,
          height: 1.5,
        ),
        labelSmall: GoogleFonts.playfairDisplay(
          color: c.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}
