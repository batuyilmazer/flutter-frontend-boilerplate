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
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.input),
          borderSide: BorderSide(color: appTheme.colors.disabled),
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
          horizontal: appTheme.spacing.inputPaddingX,
          vertical: appTheme.spacing.inputPaddingY,
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
          foregroundColor: appTheme.colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.button),
          ),
          textStyle: appTheme.typography.button,
          padding: EdgeInsets.symmetric(
            horizontal: appTheme.spacing.buttonPaddingX,
            vertical: appTheme.spacing.buttonPaddingY,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appTheme.colors.textPrimary,
          side: BorderSide(color: appTheme.colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.button),
          ),
          textStyle: appTheme.typography.button,
          padding: EdgeInsets.symmetric(
            horizontal: appTheme.spacing.buttonPaddingX,
            vertical: appTheme.spacing.buttonPaddingY,
          ),
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: appTheme.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.card),
          side: BorderSide(color: appTheme.colors.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: appTheme.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.dialog),
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
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(appTheme.radius.sheet),
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
          borderRadius: BorderRadius.circular(appTheme.radius.chip),
        ),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return appTheme.colors.disabled;
          }
          if (states.contains(WidgetState.selected)) {
            return appTheme.colors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: appTheme.colors.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.checkbox),
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

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return appTheme.colors.disabled;
          }
          if (states.contains(WidgetState.selected)) {
            return appTheme.colors.primary;
          }
          return appTheme.colors.textSecondary;
        }),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appTheme.colors.primary,
        linearTrackColor: appTheme.colors.border,
        circularTrackColor: appTheme.colors.border,
      ),

      // Tab bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: appTheme.colors.primary,
        unselectedLabelColor: appTheme.colors.textSecondary,
        labelStyle: appTheme.typography.button,
        unselectedLabelStyle: appTheme.typography.button,
        indicatorColor: appTheme.colors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: appTheme.colors.divider,
      ),

      // Date picker theme
      datePickerTheme: DatePickerThemeData(
        backgroundColor: appTheme.colors.surface,
        headerBackgroundColor: appTheme.colors.primary,
        headerForegroundColor: appTheme.colors.onPrimary,
        dayStyle: appTheme.typography.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.datePicker),
        ),
      ),

      // Dropdown menu theme
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: appTheme.colors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(appTheme.radius.input),
            borderSide: BorderSide(color: appTheme.colors.border),
          ),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: appTheme.colors.divider,
        thickness: 1,
        space: 1,
      ),

      // Snackbar theme (for Toast)
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appTheme.colors.surface,
        contentTextStyle: appTheme.typography.body.copyWith(
          color: appTheme.colors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appTheme.radius.toast),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: appTheme.colors.surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(0)),
        ),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: appTheme.colors.primary,
        inactiveTrackColor: appTheme.colors.border,
        thumbColor: appTheme.colors.primary,
        overlayColor: appTheme.colors.primary.withValues(alpha: 0.12),
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
