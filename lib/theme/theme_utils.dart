import 'package:flutter/material.dart';

/// Extension that provides theme-aware adaptive colors for dark/light mode.
/// Use `context.isDark`, `context.cardColor`, etc. in any widget.
extension ThemeAwareColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Surface / scaffold
  Color get adaptiveSurface => isDark ? const Color(0xFF121218) : const Color(0xFFFCF9F8);

  // Cards & containers
  Color get cardColor => isDark
      ? Colors.white.withValues(alpha: 0.07)
      : Colors.white.withValues(alpha: 0.5);

  Color get cardColorStrong => isDark
      ? Colors.white.withValues(alpha: 0.10)
      : Colors.white.withValues(alpha: 0.8);

  Color get cardBorder => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.white.withValues(alpha: 0.3);

  // Text colors
  Color get textPrimary => isDark ? const Color(0xFFE5E2E1) : const Color(0xFF1B1B1C);

  Color get textSecondary => isDark ? const Color(0xFFA0A0B0) : const Color(0xFF464555);

  Color get textHint => isDark
      ? const Color(0xFF6A6A7A)
      : const Color(0xFF464555).withValues(alpha: 0.5);

  // Input fields
  Color get inputFill => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.white.withValues(alpha: 0.5);

  Color get inputFillStrong => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.white.withValues(alpha: 0.6);

  // Shadows — invisible in dark, subtle in light
  Color get subtleShadow => isDark
      ? Colors.transparent
      : Colors.black.withValues(alpha: 0.04);

  Color get cardShadow => isDark
      ? Colors.transparent
      : Colors.black.withValues(alpha: 0.03);

  // Overlays
  Color get overlayLight => isDark
      ? Colors.white.withValues(alpha: 0.04)
      : Colors.white.withValues(alpha: 0.45);

  // Bottom nav & app bars
  Color get navBarColor => isDark
      ? const Color(0xFF1A1A24)
      : Colors.white;

  Color get navBarBorder => isDark
      ? Colors.white.withValues(alpha: 0.06)
      : const Color(0xFFE5E2E1);

  // Chip / badge backgrounds
  Color get chipBg => isDark
      ? Colors.white.withValues(alpha: 0.08)
      : const Color(0xFFE5E2E1);
}
