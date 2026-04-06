import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color mainTitleColor;
  final Color subtitleColor;

  const AppThemeExtension({
    required this.mainTitleColor,
    required this.subtitleColor,
  });

  @override
  AppThemeExtension copyWith({
    Color? mainTitleColor,
    Color? subtitleColor,
  }) {
    return AppThemeExtension(
      mainTitleColor: mainTitleColor ?? this.mainTitleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      mainTitleColor: Color.lerp(mainTitleColor, other.mainTitleColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}
