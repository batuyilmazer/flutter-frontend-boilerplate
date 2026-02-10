import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A loading placeholder with a shimmer animation.
///
/// ```dart
/// AppSkeleton(width: 200, height: 20)
/// AppSkeleton(width: double.infinity, height: 120, borderRadius: 16)
/// AppSkeleton.circle(size: 48)
/// ```
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({super.key, this.width, this.height, this.borderRadius})
    : _isCircle = false;

  const AppSkeleton.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null,
      _isCircle = true;

  /// Width of the skeleton. Defaults to double.infinity.
  final double? width;

  /// Height of the skeleton. Defaults to 16.
  final double? height;

  /// Border radius. Defaults to [AppRadiusScheme.small].
  final double? borderRadius;

  final bool _isCircle;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = context.appRadius;

    final baseColor = colors.surfaceVariant;
    final highlightColor = colors.surface;

    final resolvedRadius = widget._isCircle
        ? radius.full
        : (widget.borderRadius ?? radius.small);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(resolvedRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
