import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_data.dart';
import '../theme_notifier.dart';
import '../color_schemes/app_color_scheme.dart';
import '../typography_schemes/app_typography_scheme.dart';
import '../spacing_schemes/app_spacing_scheme.dart';
import '../radius_schemes/app_radius_scheme.dart';
import '../size_schemes/app_size_scheme.dart';
import '../shadow_schemes/app_shadow_scheme.dart';

/// Convenient extensions on [BuildContext] for accessing theme-related data.
///
/// These helpers provide a single, consistent way to access:
/// - Flutter's [ThemeData] and [ColorScheme]
/// - App-specific theme tokens via [AppThemeData]
/// - The [ThemeNotifier] instance
extension ThemeContextExtensions on BuildContext {
  /// Shorthand for [Theme.of].
  ThemeData get theme => Theme.of(this);

  /// Shorthand for [Theme.of].colorScheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Access the global [ThemeNotifier] using Provider.
  ThemeNotifier get themeNotifier => read<ThemeNotifier>();

  /// Current [AppThemeData] from [ThemeNotifier].
  AppThemeData get appTheme => themeNotifier.currentThemeData;

  /// App-specific color tokens.
  AppColorScheme get appColors => appTheme.colors;

  /// App-specific typography tokens.
  AppTypographyScheme get appTypography => appTheme.typography;

  /// App-specific spacing tokens.
  AppSpacingScheme get appSpacing => appTheme.spacing;

  /// App-specific radius tokens.
  AppRadiusScheme get appRadius => appTheme.radius;

  /// App-specific component size tokens.
  AppSizeScheme get appSizes => appTheme.sizes;

  /// App-specific shadow / elevation tokens.
  AppShadowScheme get appShadows => appTheme.shadows;
}
