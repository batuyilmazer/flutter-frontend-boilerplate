import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A single accordion section.
class AppAccordionItem {
  const AppAccordionItem({
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
    this.leading,
  });

  /// Header title text.
  final String title;

  /// Content displayed when expanded.
  final Widget content;

  /// Whether this item starts expanded.
  final bool initiallyExpanded;

  /// Optional leading widget in the header.
  final Widget? leading;
}

/// A themed accordion / expandable section list.
///
/// ```dart
/// AppAccordion(
///   items: [
///     AppAccordionItem(title: 'Section 1', content: Text('Content 1')),
///     AppAccordionItem(title: 'Section 2', content: Text('Content 2')),
///   ],
/// )
/// ```
class AppAccordion extends StatelessWidget {
  const AppAccordion({
    super.key,
    required this.items,
    this.dividerColor,
    this.allowMultiple = false,
  });

  /// The list of accordion sections.
  final List<AppAccordionItem> items;

  /// Divider color between items. Defaults to [AppColorScheme.border].
  final Color? dividerColor;

  /// Whether multiple sections can be open at the same time.
  /// Note: when false, Flutter's ExpansionPanelList handles exclusivity.
  final bool allowMultiple;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    return Theme(
      data: Theme.of(
        context,
      ).copyWith(dividerColor: dividerColor ?? colors.border),
      child: Column(
        children: items.map((item) {
          return _AccordionTile(
            item: item,
            colors: colors,
            spacing: spacing,
            typography: typography,
          );
        }).toList(),
      ),
    );
  }
}

class _AccordionTile extends StatelessWidget {
  const _AccordionTile({
    required this.item,
    required this.colors,
    required this.spacing,
    required this.typography,
  });

  final AppAccordionItem item;
  final dynamic colors;
  final dynamic spacing;
  final dynamic typography;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final appSpacing = context.appSpacing;
    final appTypography = context.appTypography;

    return ExpansionTile(
      initiallyExpanded: item.initiallyExpanded,
      leading: item.leading,
      title: Text(
        item.title,
        style: appTypography.body.copyWith(
          fontWeight: FontWeight.w600,
          color: appColors.textPrimary,
        ),
      ),
      iconColor: appColors.textSecondary,
      collapsedIconColor: appColors.textSecondary,
      tilePadding: EdgeInsets.symmetric(
        horizontal: appSpacing.s16,
        vertical: appSpacing.s4,
      ),
      childrenPadding: EdgeInsets.only(
        left: appSpacing.s16,
        right: appSpacing.s16,
        bottom: appSpacing.s16,
      ),
      children: [item.content],
    );
  }
}
