/// Spacing scheme containing all spacing tokens used in the app.
///
/// Provides consistent spacing values for padding, margins, and gaps.
/// Built on a 4px base-unit grid with useful intermediate stops.
class AppSpacingScheme {
  const AppSpacingScheme({
    required this.s0,
    required this.s2,
    required this.s4,
    required this.s6,
    required this.s8,
    required this.s12,
    required this.s16,
    required this.s20,
    required this.s24,
    required this.s32,
    required this.s40,
    required this.s48,
    required this.s64,
  });

  /// No spacing (0px)
  final double s0;

  /// Tiny spacing (2px)
  final double s2;

  /// Extra small spacing (4px)
  final double s4;

  /// Small-extra spacing (6px)
  final double s6;

  /// Small spacing (8px)
  final double s8;

  /// Medium-small spacing (12px)
  final double s12;

  /// Medium spacing (16px)
  final double s16;

  /// Medium-large spacing (20px)
  final double s20;

  /// Large spacing (24px)
  final double s24;

  /// Extra large spacing (32px)
  final double s32;

  /// 2x large spacing (40px)
  final double s40;

  /// 3x large spacing (48px)
  final double s48;

  /// 4x large spacing (64px)
  final double s64;
}

/// Default spacing scheme implementation.
///
/// Uses standard 4px base unit spacing scale with useful intermediate stops.
class DefaultSpacingScheme extends AppSpacingScheme {
  const DefaultSpacingScheme()
    : super(
        s0: 0,
        s2: 2,
        s4: 4,
        s6: 6,
        s8: 8,
        s12: 12,
        s16: 16,
        s20: 20,
        s24: 24,
        s32: 32,
        s40: 40,
        s48: 48,
        s64: 64,
      );
}
