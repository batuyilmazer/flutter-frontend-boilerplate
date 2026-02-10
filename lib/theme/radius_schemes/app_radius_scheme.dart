/// Radius scheme containing all border radius tokens used in the app.
///
/// Provides consistent corner rounding values for buttons, cards, inputs, etc.
class AppRadiusScheme {
  const AppRadiusScheme({
    required this.none,
    required this.small,
    required this.medium,
    required this.large,
    required this.xl,
    required this.full,
  });

  /// No border radius (0px)
  final double none;

  /// Small border radius (4px)
  final double small;

  /// Medium border radius (8px)
  final double medium;

  /// Large border radius (16px)
  final double large;

  /// Extra-large border radius (24px)
  final double xl;

  /// Full / pill / circle border radius (9999px)
  final double full;
}

/// Default radius scheme implementation.
///
/// Uses standard border radius values with a pill option.
class DefaultRadiusScheme extends AppRadiusScheme {
  const DefaultRadiusScheme()
    : super(none: 0, small: 4, medium: 8, large: 16, xl: 24, full: 9999);
}
