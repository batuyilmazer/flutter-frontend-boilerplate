import 'package:freezed_annotation/freezed_annotation.dart';
import 'color_schemes/app_color_scheme.dart';
import 'color_schemes/light_color_scheme.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'typography_schemes/app_typography_scheme.dart';
import 'spacing_schemes/app_spacing_scheme.dart';
import 'radius_schemes/app_radius_scheme.dart';

part 'theme_data.freezed.dart';

/// Immutable data class containing all theme tokens.
///
/// This is the central theme configuration that combines:
/// - Colors (AppColorScheme)
/// - Typography (AppTypographyScheme)
/// - Spacing (AppSpacingScheme)
/// - Radius (AppRadiusScheme)
///
/// Use factory constructors to create light or dark theme instances.
@freezed
class AppThemeData with _$AppThemeData {
  const AppThemeData._();

  const factory AppThemeData({
    required AppColorScheme colors,
    required AppTypographyScheme typography,
    required AppSpacingScheme spacing,
    required AppRadiusScheme radius,
  }) = _AppThemeData;

  /// Creates a light theme configuration.
  ///
  /// Uses [LightColorScheme] and default typography, spacing, and radius schemes.
  factory AppThemeData.light() => AppThemeData(
    colors: const LightColorScheme(),
    typography: const DefaultTypographyScheme(),
    spacing: const DefaultSpacingScheme(),
    radius: const DefaultRadiusScheme(),
  );

  /// Creates a dark theme configuration.
  ///
  /// Uses [DarkColorScheme] and default typography, spacing, and radius schemes.
  factory AppThemeData.dark() => AppThemeData(
    colors: const DarkColorScheme(),
    typography: const DefaultTypographyScheme(),
    spacing: const DefaultSpacingScheme(),
    radius: const DefaultRadiusScheme(),
  );
}
