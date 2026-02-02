/// Radius scheme containing all border radius tokens used in the app.
///
/// Provides consistent corner rounding values for buttons, cards, inputs, etc.
class AppRadiusScheme {
  const AppRadiusScheme({
    required this.small,
    required this.medium,
    required this.large,
  });

  /// Small border radius (4px)
  final double small;

  /// Medium border radius (8px)
  final double medium;

  /// Large border radius (16px)
  final double large;
}

/// Default radius scheme implementation.
///
/// Uses standard border radius values.
class DefaultRadiusScheme extends AppRadiusScheme {
  const DefaultRadiusScheme() : super(small: 4, medium: 8, large: 16);
}
