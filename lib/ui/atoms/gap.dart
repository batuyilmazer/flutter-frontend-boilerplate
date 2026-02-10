import 'package:flutter/material.dart';

/// A gap widget that renders an empty [SizedBox] with both height and width.
///
/// Useful as spacing between widgets in any direction (works in both
/// [Row], [Column], [Wrap], etc.).
///
/// ```dart
/// Column(children: [
///   Text('Hello'),
///   Gap(context.appSpacing.s16),
///   Text('World'),
/// ]);
/// ```
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  /// The size of the gap (used for both height and width).
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size);
  }
}

/// A horizontal-only gap (width only).
///
/// Useful inside [Row] or [Wrap] for horizontal spacing.
class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});

  /// The width of the gap.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size);
  }
}

/// A vertical-only gap (height only).
///
/// Useful inside [Column] for vertical spacing.
class VGap extends StatelessWidget {
  const VGap(this.size, {super.key});

  /// The height of the gap.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size);
  }
}
