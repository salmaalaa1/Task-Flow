import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF4D41DF);
  static const Color primaryContainer = Color(0xFF675DF9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);
  static const Color primaryFixed = Color(0xFFE3DFFF);
  static const Color primaryFixedDim = Color(0xFFC4C0FF);
  static const Color onPrimaryFixed = Color(0xFF100069);
  static const Color onPrimaryFixedVariant = Color(0xFF3622CA);
  static const Color inversePrimary = Color(0xFFC4C0FF);

  // Secondary
  static const Color secondary = Color(0xFF5B5F62);
  static const Color secondaryContainer = Color(0xFFDDE0E4);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF606366);
  static const Color secondaryFixed = Color(0xFFE0E3E6);
  static const Color secondaryFixedDim = Color(0xFFC4C7CA);
  static const Color onSecondaryFixed = Color(0xFF181C1F);
  static const Color onSecondaryFixedVariant = Color(0xFF44474A);

  // Tertiary
  static const Color tertiary = Color(0xFFAC2649);
  static const Color tertiaryContainer = Color(0xFFCE4060);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFFFFFBFF);
  static const Color tertiaryFixed = Color(0xFFFFD9DD);
  static const Color tertiaryFixedDim = Color(0xFFFFB2BC);
  static const Color onTertiaryFixed = Color(0xFF400012);
  static const Color onTertiaryFixedVariant = Color(0xFF8F0935);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceBright = Color(0xFFFCF9F8);
  static const Color surfaceDim = Color(0xFFDCD9D9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);
  static const Color surfaceVariant = Color(0xFFE5E2E1);
  static const Color surfaceTint = Color(0xFF4F44E2);
  static const Color onSurface = Color(0xFF1B1B1C);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);

  // Outline
  static const Color outline = Color(0xFF777587);
  static const Color outlineVariant = Color(0xFFC7C4D8);

  // Background
  static const Color background = Color(0xFFFCF9F8);
  static const Color onBackground = Color(0xFF1B1B1C);

  // Category colors
  static const Color categoryWork = Color(0xFF3B82F6);
  static const Color categoryWorkBg = Color(0xFFDBEAFE);
  static const Color categoryPersonal = Color(0xFFEC4899);
  static const Color categoryPersonalBg = Color(0xFFFCE7F3);
  static const Color categoryHealth = Color(0xFFF97316);
  static const Color categoryHealthBg = Color(0xFFFFEDD5);
  static const Color categoryStudy = Color(0xFF8B5CF6);
  static const Color categoryStudyBg = Color(0xFFEDE9FE);
  static const Color categoryFinance = Color(0xFF10B981);
  static const Color categoryFinanceBg = Color(0xFFD1FAE5);

  // Priority colors
  static const Color urgentRed = Color(0xFFEF4444);
  static const Color urgentRedBg = Color(0xFFFEF2F2);
  static const Color mediumAmber = Color(0xFFFBBF24);
  static const Color mediumAmberBg = Color(0xFFFFFBEB);
  static const Color lowGreen = Color(0xFF22C55E);
  static const Color lowGreenBg = Color(0xFFF0FDF4);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
