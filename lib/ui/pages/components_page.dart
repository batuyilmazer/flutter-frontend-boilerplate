import 'package:flutter/material.dart';

import '../ui.dart';
import '../../theme/extensions/theme_context_extensions.dart';
import '../../theme/size_schemes/app_size_scheme.dart';

/// Showcase page that renders all atoms and molecules
/// to help visualize the design system in one place.
class ComponentsPage extends StatefulWidget {
  const ComponentsPage({super.key});

  @override
  State<ComponentsPage> createState() => _ComponentsPageState();
}

class _ComponentsPageState extends State<ComponentsPage> {
  bool _checkboxChecked = true;
  bool _switchOn = true;
  String _toggleView = 'list';
  String _selectValue = 'a';
  int _currentPage = 2;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Components'),
        backgroundColor: colors.surface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'Atoms',
              children: [
                _AtomRow(
                  label: 'Buttons',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Normal width buttons (md)
                      Row(
                        children: [
                          AppButton(
                            label: 'Primary',
                            onPressed: () => _showSnack(context, 'Primary tapped'),
                          ),
                          SizedBox(width: 8),
                          AppButton(
                            label: 'Secondary',
                            variant: AppButtonVariant.secondary,
                            onPressed: () =>
                                _showSnack(context, 'Secondary tapped'),
                          ),
                          SizedBox(width: 8),
                          AppButton(
                            label: 'Outline',
                            variant: AppButtonVariant.outline,
                            onPressed: () =>
                                _showSnack(context, 'Outline tapped'),
                          ),
                          SizedBox(width: 8),
                          AppButton(
                            label: 'Text',
                            variant: AppButtonVariant.text,
                            onPressed: () => _showSnack(context, 'Text tapped'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Small buttons
                      Row(
                        children: [
                          AppButton(
                            label: 'Sm primary',
                            size: AppComponentSize.sm,
                            onPressed: () =>
                                _showSnack(context, 'Sm primary tapped'),
                          ),
                          SizedBox(width: 8),
                          AppButton(
                            label: 'Sm secondary',
                            size: AppComponentSize.sm,
                            variant: AppButtonVariant.secondary,
                            onPressed: () =>
                                _showSnack(context, 'Sm secondary tapped'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Large buttons
                      Row(
                        children: [
                          AppButton(
                            label: 'Lg primary',
                            size: AppComponentSize.lg,
                            onPressed: () =>
                                _showSnack(context, 'Lg primary tapped'),
                          ),
                          SizedBox(width: 8),
                          AppButton(
                            label: 'Lg secondary',
                            size: AppComponentSize.lg,
                            variant: AppButtonVariant.secondary,
                            onPressed: () =>
                                _showSnack(context, 'Lg secondary tapped'),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      // Full-width button
                      AppButton(
                        label: 'Full width button',
                        isFullWidth: true,
                        onPressed: () =>
                            _showSnack(context, 'Full width tapped'),
                      ),
                      SizedBox(height: 12),
                      // Half-width button (50% of available width)
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: AppButton(
                          label: 'Half width button',
                          isFullWidth: true,
                          onPressed: () =>
                              _showSnack(context, 'Half width tapped'),
                        ),
                      ),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Text',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.headline('Headline'),
                      AppText.title('Title'),
                      AppText.body('Body text'),
                      AppText.bodySmall('Body small'),
                      AppText.caption('Caption'),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Inputs',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(label: 'Text field', hint: 'Placeholder'),
                      SizedBox(height: 12),
                      AppTextarea(
                        label: 'Textarea',
                        hint: 'Multi-line text...',
                      ),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Selection',
                  child: Row(
                    children: [
                      AppCheckbox(
                        value: _checkboxChecked,
                        onChanged: (v) {
                          setState(() => _checkboxChecked = v);
                        },
                        label: 'Checkbox',
                      ),
                      SizedBox(width: 16),
                      AppSwitch(
                        value: _switchOn,
                        onChanged: (v) {
                          setState(() => _switchOn = v);
                        },
                        label: 'Switch',
                      ),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Status',
                  child: Row(
                    children: [
                      AppBadge(label: 'Primary'),
                      SizedBox(width: 8),
                      AppBadge(
                        label: 'Success',
                        variant: AppBadgeVariant.success,
                      ),
                      SizedBox(width: 8),
                      AppBadge(
                        label: 'Warning',
                        variant: AppBadgeVariant.warning,
                      ),
                      SizedBox(width: 8),
                      AppBadge(
                        label: 'Error',
                        variant: AppBadgeVariant.error,
                      ),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Feedback',
                  child: Row(
                    children: [
                      AppSpinner(),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 120,
                        child: AppProgress(value: 0.6),
                      ),
                    ],
                  ),
                ),
                _AtomRow(
                  label: 'Card & Alert',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCard(
                        child: AppText.body('Card content'),
                      ),
                      SizedBox(height: 12),
                      AppAlert(
                        title: 'Alert title',
                        message: 'Inline alert message for info state.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing.sectionGapLg),
            _Section(
              title: 'Molecules',
              children: [
                const _AtomRow(
                  label: 'Labeled Text Field',
                  child: LabeledTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                  ),
                ),
                const SizedBox(height: 16),
                _AtomRow(
                  label: 'Select',
                  child: AppSelect<String>(
                    items: const [
                      AppSelectItem(value: 'a', label: 'Option A'),
                      AppSelectItem(value: 'b', label: 'Option B'),
                    ],
                    value: _selectValue,
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _selectValue = v);
                    },
                    hint: 'Select an option',
                  ),
                ),
                const SizedBox(height: 16),
                _AtomRow(
                  label: 'Toggle Group',
                  child: AppToggleGroup<String>(
                    items: const [
                      AppToggleItem(value: 'list', label: 'List'),
                      AppToggleItem(value: 'grid', label: 'Grid'),
                    ],
                    value: _toggleView,
                    onChanged: (v) {
                      setState(() => _toggleView = v);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _AtomRow(
                  label: 'Tabs',
                  child: AppTabs(
                    contentHeight: 160,
                    tabs: const [
                      AppTabItem(
                        label: 'Tab 1',
                        content: Center(child: AppText.body('Tab 1 content')),
                      ),
                      AppTabItem(
                        label: 'Tab 2',
                        content: Center(child: AppText.body('Tab 2 content')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _AtomRow(
                  label: 'Accordion',
                  child: AppAccordion(
                    items: const [
                      AppAccordionItem(
                        title: 'Section 1',
                        content: AppText.body('Accordion content 1'),
                      ),
                      AppAccordionItem(
                        title: 'Section 2',
                        content: AppText.body('Accordion content 2'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _AtomRow(
                  label: 'Pagination',
                  child: AppPagination(
                    currentPage: _currentPage,
                    totalPages: 5,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.title(
          title,
          color: colors.textPrimary,
        ),
        SizedBox(height: spacing.sectionGapSm),
        ...children,
      ],
    );
  }
}

class _AtomRow extends StatelessWidget {
  const _AtomRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;
    final typography = context.appTypography;
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sectionGapMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: typography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.s8),
          child,
        ],
      ),
    );
  }
}

