import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color accent;
  final Color onAccent;
  final Color green;
  final Color error;
  final Color errorContainer;
  final Color danger;
  final Color avatarBackground;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color skeletonImage;
  final Color skeletonLine;

  const AppColors({
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.accent,
    required this.onAccent,
    required this.green,
    required this.error,
    required this.errorContainer,
    required this.danger,
    required this.avatarBackground,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.skeletonImage,
    required this.skeletonLine,
  });

  // 1. Giao diện Sáng (Light Mode)
  static const light = AppColors(
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF1C2520),
    muted: Color(0xFF768079),
    line: Color(0xFFE8ECE8),
    accent: Color(0xFFD2F36B),
    onAccent: Color(0xFF1C2520),
    green: Color(0xFF526C30),
    error: Color(0xFFD32F2F),
    errorContainer: Color(0xFFFDE8E8),
    danger: Color(0xFFE53935),
    avatarBackground: Color(0xFFE7EDD9),
    warning: Color(0xFFED6C02),
    warningContainer: Color(0xFFFFF4E5),
    info: Color(0xFF0288D1),
    infoContainer: Color(0xFFE1F5FE),
    skeletonBase: Color(0xFFE2E8E3),
    skeletonHighlight: Color(0xFFF5F8F5),
    skeletonImage: Color(0xFFC0CAC2),
    skeletonLine: Color(0xFFD4DCD5),
  );

  // 2. Giao diện Tối (Dark Mode)
  static const dark = AppColors(
    background: Color(0xFF0F1411),
    surface: Color(0xFF1C2520),
    ink: Color(0xFFF0F4EC),
    muted: Color(0xFF9BA69E),
    line: Color(0xFF2A362E),
    accent: Color(0xFFD2F36B),
    onAccent: Color(0xFF0F1411),
    green: Color(0xFF82B045),
    error: Color(0xFFEF5350),
    errorContainer: Color(0xFF3B1D1D),
    danger: Color(0xFFEF5350),
    avatarBackground: Color(0xFF2E3B34),
    warning: Color(0xFFFFA726),
    warningContainer: Color(0xFF33271D),
    info: Color(0xFF29B6F6),
    infoContainer: Color(0xFF1A2A3A),
    skeletonBase: Color(0xFF2A3730),
    skeletonHighlight: Color(0xFF35453C),
    skeletonImage: Color(0xFF1E2822),
    skeletonLine: Color(0xFF26332C),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? background,
    Color? surface,
    Color? ink,
    Color? muted,
    Color? line,
    Color? accent,
    Color? onAccent,
    Color? green,
    Color? error,
    Color? errorContainer,
    Color? danger,
    Color? avatarBackground,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? skeletonImage,
    Color? skeletonLine,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      green: green ?? this.green,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      danger: danger ?? this.danger,
      avatarBackground: avatarBackground ?? this.avatarBackground,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      skeletonImage: skeletonImage ?? this.skeletonImage,
      skeletonLine: skeletonLine ?? this.skeletonLine,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      green: Color.lerp(green, other.green, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      avatarBackground: Color.lerp(
        avatarBackground,
        other.avatarBackground,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
      skeletonImage: Color.lerp(skeletonImage, other.skeletonImage, t)!,
      skeletonLine: Color.lerp(skeletonLine, other.skeletonLine, t)!,
    );
  }
}
