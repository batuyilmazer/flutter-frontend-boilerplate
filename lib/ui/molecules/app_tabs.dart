import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import '../../theme/extensions/theme_context_extensions.dart';

/// A single tab item for [AppTabs].
class AppTabItem {
  const AppTabItem({required this.label, required this.content, this.icon});

  /// Tab label text.
  final String label;

  /// Widget rendered when this tab is selected.
  final Widget content;

  /// Optional tab icon.
  final Widget? icon;
}

/// A themed tab bar with corresponding tab views.
///
/// ```dart
/// AppTabs(
///   tabs: [
///     AppTabItem(label: 'Tab 1', content: Text('Content 1')),
///     AppTabItem(label: 'Tab 2', content: Text('Content 2')),
///   ],
/// )
/// ```
class AppTabs extends StatefulWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    this.controller,
    this.initialIndex = 0,
    this.onChanged,
    this.isScrollable = false,
    this.contentPadding,
    this.contentHeight,
  });

  /// The list of tabs.
  final List<AppTabItem> tabs;

  /// Optional external [TabController].
  final TabController? controller;

  /// Initial selected tab index.
  final int initialIndex;

  /// Called when the selected tab changes.
  final ValueChanged<int>? onChanged;

  /// Whether the tab bar is scrollable.
  final bool isScrollable;

  /// Padding around the tab content area.
  final EdgeInsetsGeometry? contentPadding;

  /// Fixed height for the tab content area.
  ///
  /// If null, a sensible default height will be used.
  final double? contentHeight;

  @override
  State<AppTabs> createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with SingleTickerProviderStateMixin {
  late TabController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _ownsController = true;
      _controller = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );
    }
    _controller.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_controller.indexIsChanging) {
      widget.onChanged?.call(_controller.index);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTabChange);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        // #region agent log
        try {
          final file = File(
            '/Users/yilmazer/offlineProj/templates/.cursor/debug-37ae70.log',
          );
          file.parent.createSync(recursive: true);
          final log = <String, dynamic>{
            'sessionId': '37ae70',
            'runId': 'pre-fix',
            'hypothesisId': 'H1',
            'location': 'lib/ui/molecules/app_tabs.dart:build',
            'message': 'AppTabs layout constraints',
            'data': {
              'minWidth': constraints.minWidth,
              'maxWidth': constraints.maxWidth,
              'minHeight': constraints.minHeight,
              'maxHeight': constraints.maxHeight,
            },
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
          file.writeAsString(
            '${jsonEncode(log)}\n',
            mode: FileMode.append,
            flush: true,
          );
        } catch (_) {}
        // #endregion

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              controller: _controller,
              isScrollable: widget.isScrollable,
              tabs: widget.tabs.map((tab) {
                if (tab.icon != null) {
                  return Tab(icon: tab.icon, text: tab.label);
                }
                return Tab(text: tab.label);
              }).toList(),
            ),
            SizedBox(
              height: widget.contentHeight ?? 160,
              child: Padding(
                padding:
                    widget.contentPadding ?? EdgeInsets.only(top: spacing.s16),
                child: TabBarView(
                  controller: _controller,
                  children: widget.tabs.map((tab) => tab.content).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
