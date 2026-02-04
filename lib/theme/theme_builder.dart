import 'package:flutter/material.dart';
import 'theme_data.dart';

/// Builder for converting [AppThemeData] to Flutter's [ThemeData].
///
/// This class provides factory methods to create MaterialApp-compatible
/// ThemeData from our custom AppThemeData configuration.
/// All Material components are themed consistently using AppThemeData tokens.
class ThemeBuilder {
  const ThemeBuilder._();

  /// Build Flutter ThemeData from AppThemeData.
  ///
  /// Converts our custom theme tokens to MaterialApp's ThemeData format.
  /// Includes all necessary theme configurations for Material components.
  static ThemeData buildThemeData(AppThemeData appTheme) {
    return ThemeData(
      // Core theme settings
      colorScheme: appTheme.colors.materialColorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: appTheme.colors.background,

      // AppBar theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: appTheme.colors.surface,
        foregroundColor: appTheme.colors.textPrimary,
        titleTextStyle: appTheme.typography.title.copyWith(
          color: appTheme.colors.textPrimary,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: appTheme.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          borderSide: BorderSide(color: appTheme.colors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          borderSide: BorderSide(color: appTheme.colors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          borderSide: BorderSide(color: appTheme.colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          borderSide: BorderSide(color: appTheme.colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          borderSide: BorderSide(color: appTheme.colors.error, width: 2),
        ),
        labelStyle: appTheme.typography.bodySmall.copyWith(
          color: appTheme.colors.textSecondary,
        ),
        hintStyle: appTheme.typography.bodySmall.copyWith(
          color: appTheme.colors.textSecondary,
        ),
        errorStyle: appTheme.typography.caption.copyWith(
          color: appTheme.colors.error,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: appTheme.spacing.s16,
          vertical: appTheme.spacing.s12,
        ),
      ),

      // Button themes
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: appTheme.colors.primary,
          textStyle: appTheme.typography.button,
          padding: EdgeInsets.symmetric(
            horizontal: appTheme.spacing.s16,
            vertical: appTheme.spacing.s8,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.medium),
          ),
          textStyle: appTheme.typography.button,
          padding: EdgeInsets.symmetric(
            horizontal: appTheme.spacing.s24,
            vertical: appTheme.spacing.s12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appTheme.colors.textPrimary,
          side: BorderSide(color: appTheme.colors.textSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.medium),
          ),
          textStyle: appTheme.typography.button,
          padding: EdgeInsets.symmetric(
            horizontal: appTheme.spacing.s24,
            vertical: appTheme.spacing.s12,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: appTheme.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
          side: BorderSide(
            color: appTheme.colors.textSecondary.withValues(alpha: 0.1),
          ),
        ),
        margin: EdgeInsets.all(appTheme.spacing.s8),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: appTheme.colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.large),
        ),
        titleTextStyle: appTheme.typography.title.copyWith(
          color: appTheme.colors.textPrimary,
        ),
        contentTextStyle: appTheme.typography.body.copyWith(
          color: appTheme.colors.textPrimary,
        ),
      ),

      // Bottom sheet theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: appTheme.colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(appTheme.radius.large),
          ),
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: appTheme.colors.background,
        selectedColor: appTheme.colors.primary.withValues(alpha: 0.2),
        labelStyle: appTheme.typography.bodySmall,
        secondaryLabelStyle: appTheme.typography.bodySmall,
        padding: EdgeInsets.symmetric(
          horizontal: appTheme.spacing.s12,
          vertical: appTheme.spacing.s8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.medium),
        ),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return appTheme.colors.primary;
          }
          return appTheme.colors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return appTheme.colors.primary.withValues(alpha: 0.5);
          }
          return appTheme.colors.textSecondary.withValues(alpha: 0.3);
        }),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: appTheme.colors.textSecondary.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: appTheme.typography.headline,
        displayMedium: appTheme.typography.headline,
        displaySmall: appTheme.typography.headline,
        headlineLarge: appTheme.typography.headline,
        headlineMedium: appTheme.typography.headline,
        headlineSmall: appTheme.typography.title,
        titleLarge: appTheme.typography.title,
        titleMedium: appTheme.typography.title,
        titleSmall: appTheme.typography.title,
        bodyLarge: appTheme.typography.body,
        bodyMedium: appTheme.typography.body,
        bodySmall: appTheme.typography.bodySmall,
        labelLarge: appTheme.typography.button,
        labelMedium: appTheme.typography.bodySmall,
        labelSmall: appTheme.typography.caption,
      ),
    );
  }
}
