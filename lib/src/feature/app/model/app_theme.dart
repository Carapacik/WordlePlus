import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wordly/src/core/resources/resources.dart';
import 'package:wordly/src/feature/settings/model/change_color_result.dart';

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class AppTheme with Diagnosticable {
  /// {@macro app_theme}
  AppTheme({
    required this.mode,
    required this.colorMode,
    this.otherColors,
  })  : darkTheme = ThemeData(
          colorSchemeSeed: otherColors?.$1 ?? Colors.green,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        lightTheme = ThemeData(
          colorSchemeSeed: otherColors?.$1 ?? Colors.green,
          brightness: Brightness.light,
          useMaterial3: true,
        );

  /// The type of theme to use.
  final ThemeMode mode;

  /// The type of color mode to use.
  final ColorMode colorMode;

  /// Other colors for cells
  final (Color, Color, Color)? otherColors;

  /// Light mode [AppTheme].
  static final light = AppTheme(mode: ThemeMode.light, colorMode: ColorMode.casual);

  /// Dark mode [AppTheme].
  static final dark = AppTheme(mode: ThemeMode.dark, colorMode: ColorMode.casual);

  /// System mode [AppTheme].
  static final system = AppTheme(mode: ThemeMode.system, colorMode: ColorMode.casual);

  /// The dark [ThemeData] for this [AppTheme].
  final ThemeData darkTheme;

  /// The light [ThemeData] for this [AppTheme].
  final ThemeData lightTheme;

  /// The [ThemeData] for this [AppTheme].
  /// This is computed based on the [mode].
  ///
  /// Could be useful for theme showcase.
  ThemeData computeTheme(BuildContext context) {
    switch (mode) {
      case ThemeMode.light:
        return lightTheme;
      case ThemeMode.dark:
        return darkTheme;
      case ThemeMode.system:
        return isDark(context) ? darkTheme : lightTheme;
    }
  }

  bool isDark(BuildContext context) => MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  Color get correctColor {
    switch (colorMode) {
      case ColorMode.casual:
        return AppColors.green;
      case ColorMode.highContrast:
        return AppColors.orange;
      case ColorMode.other:
        return otherColors?.$1 ?? AppColors.green;
    }
  }

  Color get wrongSpotColor {
    switch (colorMode) {
      case ColorMode.casual:
        return AppColors.yellow;
      case ColorMode.highContrast:
        return AppColors.blue;
      case ColorMode.other:
        return otherColors?.$2 ?? AppColors.yellow;
    }
  }

  Color notInWordColor(BuildContext context) {
    final isDarkTheme = isDark(context);
    switch (colorMode) {
      case ColorMode.casual:
      case ColorMode.highContrast:
        return isDarkTheme ? AppColors.tertiary : AppColors.grey;
      case ColorMode.other:
        return otherColors?.$3 ?? (isDarkTheme ? AppColors.tertiary : AppColors.grey);
    }
  }

  Color unknownColor(BuildContext context) {
    final isDarkTheme = isDark(context);
    return isDarkTheme ? AppColors.grey : AppColors.tertiary;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppTheme &&
          runtimeType == other.runtimeType &&
          mode == other.mode &&
          colorMode == other.colorMode &&
          otherColors == other.otherColors;

  @override
  int get hashCode => mode.hashCode ^ colorMode.hashCode ^ otherColors.hashCode;

  AppTheme copyWith({
    ThemeMode? themeMode,
    ColorMode? colorMode,
    (Color, Color, Color)? otherColors,
  }) {
    return AppTheme(
      mode: themeMode ?? mode,
      colorMode: colorMode ?? this.colorMode,
      otherColors: otherColors ?? this.otherColors,
    );
  }
}
