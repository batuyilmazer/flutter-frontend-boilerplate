/// Radius scheme containing all border radius tokens used in the app.
///
/// Provides consistent corner rounding values for buttons, cards, inputs, etc.
class AppRadiusScheme {
  const AppRadiusScheme({
    // Semantic / component-level radius tokens
    required this.small,
    required this.full,
    required this.button,
    required this.card,
    required this.input,
    required this.dialog,
    required this.sheet,
    required this.badge,
    required this.alert,
    required this.chip,
    required this.toast,
    required this.popover,
    required this.contextMenu,
    required this.calendar,
    required this.toggle,
    required this.pagination,
    required this.avatar,
    required this.indicator,
    required this.checkbox,
    required this.datePicker,
  });

  /// Small border radius (4px)
  final double small;

  /// Full / pill / circle border radius (9999px)
  final double full;

  // --- Semantic / component-level radius tokens ---

  /// Default corner radius for buttons.
  final double button;

  /// Default corner radius for cards / surfaces.
  final double card;

  /// Default corner radius for inputs (text fields, selects, etc.).
  final double input;

  /// Default corner radius for dialogs.
  final double dialog;

  /// Default corner radius for bottom sheets.
  final double sheet;

  /// Default corner radius for badges (usually pill).
  final double badge;

  /// Default corner radius for alerts.
  final double alert;

  /// Default corner radius for chips.
  final double chip;

  /// Default corner radius for toast / snackbar.
  final double toast;

  /// Default corner radius for popovers / tooltips.
  final double popover;

  /// Default corner radius for context menus.
  final double contextMenu;

  /// Default corner radius for calendar cells / surfaces.
  final double calendar;

  /// Default corner radius for toggle groups / segmented controls.
  final double toggle;

  /// Default corner radius for pagination controls.
  final double pagination;

  /// Default corner radius for non-circular avatars.
  final double avatar;

  /// Default corner radius for carousel indicators / small UI dots.
  final double indicator;

  /// Default corner radius for checkboxes.
  final double checkbox;

  /// Default corner radius for date pickers.
  final double datePicker;
}

/// Default radius scheme implementation.
///
/// Uses standard border radius values with a pill option.
class DefaultRadiusScheme extends AppRadiusScheme {
  const DefaultRadiusScheme()
    : super(
        small: 6,
        full: 9999,

        // Semantic / component-level radius tokens
        button: 8,
        card: 8,
        input: 8,
        dialog: 12,
        sheet: 12,
        badge: 9999,
        alert: 8,
        chip: 8,
        toast: 8,
        popover: 8,
        contextMenu: 8,
        calendar: 8,
        toggle: 8,
        pagination: 8,
        avatar: 8,
        indicator: 6,
        checkbox: 6,
        datePicker: 12,
      );
}
