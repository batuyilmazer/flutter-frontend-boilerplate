/// Spacing scheme containing all spacing tokens used in the app.
///
/// Provides consistent spacing values for padding, margins, and gaps.
class AppSpacingScheme {
  const AppSpacingScheme({
    required this.s4,
    required this.s8,
    required this.s12,
    required this.s16,
    required this.s24,
    required this.s32,
  });

  /// Extra small spacing (4px)
  final double s4;

  /// Small spacing (8px)
  final double s8;

  /// Medium-small spacing (12px)
  final double s12;

  /// Medium spacing (16px)
  final double s16;

  /// Large spacing (24px)
  final double s24;

  /// Extra large spacing (32px)
  final double s32;
}

/// Default spacing scheme implementation.
///
/// Uses standard 4px base unit spacing scale.
class DefaultSpacingScheme extends AppSpacingScheme {
  const DefaultSpacingScheme()
    : super(s4: 4, s8: 8, s12: 12, s16: 16, s24: 24, s32: 32);
}
