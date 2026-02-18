import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed pagination control.
///
/// ```dart
/// AppPagination(
///   currentPage: 3,
///   totalPages: 10,
///   onPageChanged: (page) => setState(() => _page = page),
/// )
/// ```
class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 5,
  });

  /// Current active page (1-based).
  final int currentPage;

  /// Total number of pages.
  final int totalPages;

  /// Called when a page is selected.
  final ValueChanged<int> onPageChanged;

  /// Maximum number of page buttons visible at once. Defaults to 5.
  final int maxVisiblePages;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    if (totalPages <= 1) return const SizedBox.shrink();

    // Calculate visible page range
    int start = (currentPage - maxVisiblePages ~/ 2).clamp(1, totalPages);
    int end = (start + maxVisiblePages - 1).clamp(1, totalPages);
    if (end - start < maxVisiblePages - 1) {
      start = (end - maxVisiblePages + 1).clamp(1, totalPages);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        _PaginationButton(
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          colors: colors,
          radius: radius,
          spacing: spacing,
          child: Icon(
            Icons.chevron_left,
            size: 20,
            color: currentPage > 1 ? colors.textPrimary : colors.textDisabled,
          ),
        ),
        SizedBox(width: spacing.s4),
        // Page buttons
        for (int i = start; i <= end; i++) ...[
          _PaginationButton(
            onTap: i != currentPage ? () => onPageChanged(i) : null,
            isActive: i == currentPage,
            colors: colors,
            radius: radius,
            spacing: spacing,
            child: Text(
              '$i',
              style: typography.bodySmall.copyWith(
                fontWeight: i == currentPage
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: colors.textPrimary,
              ),
            ),
          ),
          if (i < end) SizedBox(width: spacing.s2),
        ],
        SizedBox(width: spacing.s4),
        // Next button
        _PaginationButton(
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
          colors: colors,
          radius: radius,
          spacing: spacing,
          child: Icon(
            Icons.chevron_right,
            size: 20,
            color: currentPage < totalPages
                ? colors.textPrimary
                : colors.textDisabled,
          ),
        ),
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.child,
    required this.colors,
    required this.radius,
    required this.spacing,
    this.onTap,
    this.isActive = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isActive;
  final dynamic colors;
  final dynamic radius;
  final dynamic spacing;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final appRadius = context.appRadius;
    final appSpacing = context.appSpacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: appSpacing.s8),
        decoration: BoxDecoration(
          color: isActive ? appColors.surfaceVariant : Colors.transparent,
          borderRadius: BorderRadius.circular(appRadius.pagination),
          border: Border.all(color: appColors.border),
        ),
        child: child,
      ),
    );
  }
}
