import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A horizontal page carousel with page indicators.
///
/// ```dart
/// AppCarousel(
///   height: 200,
///   children: [
///     Image.network('https://...'),
///     Image.network('https://...'),
///   ],
/// )
/// ```
class AppCarousel extends StatefulWidget {
  const AppCarousel({
    super.key,
    required this.children,
    this.height = 200,
    this.autoPlay = false,
    this.autoPlayDuration = const Duration(seconds: 4),
    this.showIndicators = true,
    this.onPageChanged,
    this.viewportFraction = 1.0,
    this.initialPage = 0,
  });

  /// The carousel pages.
  final List<Widget> children;

  /// Height of the carousel. Defaults to 200.
  final double height;

  /// Whether to auto-advance pages. Defaults to false.
  final bool autoPlay;

  /// Duration between auto-play transitions.
  final Duration autoPlayDuration;

  /// Whether to show dot indicators. Defaults to true.
  final bool showIndicators;

  /// Called when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// Fraction of viewport each page occupies. Defaults to 1.0.
  final double viewportFraction;

  /// Initial page index.
  final int initialPage;

  @override
  State<AppCarousel> createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _controller = PageController(
      initialPage: widget.initialPage,
      viewportFraction: widget.viewportFraction,
    );
    if (widget.autoPlay) _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.doWhile(() async {
      await Future.delayed(widget.autoPlayDuration);
      if (!mounted) return false;
      final nextPage = (_currentPage + 1) % widget.children.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return mounted && widget.autoPlay;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.children.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              widget.onPageChanged?.call(index);
            },
            itemBuilder: (context, index) => widget.children[index],
          ),
        ),
        if (widget.showIndicators && widget.children.length > 1) ...[
          SizedBox(height: spacing.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.children.length, (index) {
              final isActive = index == _currentPage;
              return Container(
                width: isActive ? 24 : 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: spacing.s2),
                decoration: BoxDecoration(
                  color: isActive
                      ? colors.primary
                      : colors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
