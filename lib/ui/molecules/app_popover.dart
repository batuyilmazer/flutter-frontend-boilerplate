import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed popover that positions content relative to a trigger widget.
///
/// Uses [OverlayEntry] + [CompositedTransformFollower] for positioning.
///
/// ```dart
/// AppPopover(
///   trigger: AppButton(label: 'Open', onPressed: null),
///   content: Padding(
///     padding: EdgeInsets.all(16),
///     child: Text('Popover content'),
///   ),
/// )
/// ```
class AppPopover extends StatefulWidget {
  const AppPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.alignment = Alignment.bottomCenter,
    this.offset = Offset.zero,
    this.barrierDismissible = true,
    this.width,
  });

  /// The widget that triggers the popover on tap.
  final Widget trigger;

  /// The popover content.
  final Widget content;

  /// Alignment of the popover relative to the trigger.
  final Alignment alignment;

  /// Offset from the aligned position.
  final Offset offset;

  /// Whether tapping outside closes the popover.
  final bool barrierDismissible;

  /// Fixed width for the popover. Auto-sized if null.
  final double? width;

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _togglePopover() {
    if (_isOpen) {
      _closePopover();
    } else {
      _openPopover();
    }
  }

  void _openPopover() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final colors = context.appColors;
    final radius = context.appRadius;
    final shadows = context.appShadows;

    return OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            // Barrier
            if (widget.barrierDismissible)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closePopover,
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                ),
              ),
            // Popover content
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: widget.offset,
              followerAnchor: _followerAnchor,
              targetAnchor: _targetAnchor,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(radius.popover),
                    border: Border.all(color: colors.border),
                    boxShadow: shadows.list(shadows.popover),
                  ),
                  child: widget.content,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Alignment get _followerAnchor {
    if (widget.alignment == Alignment.bottomCenter) return Alignment.topCenter;
    if (widget.alignment == Alignment.topCenter) return Alignment.bottomCenter;
    if (widget.alignment == Alignment.centerRight) return Alignment.centerLeft;
    if (widget.alignment == Alignment.centerLeft) return Alignment.centerRight;
    return Alignment.topCenter;
  }

  Alignment get _targetAnchor {
    if (widget.alignment == Alignment.bottomCenter) {
      return Alignment.bottomCenter;
    }
    if (widget.alignment == Alignment.topCenter) {
      return Alignment.topCenter;
    }
    if (widget.alignment == Alignment.centerRight) {
      return Alignment.centerRight;
    }
    if (widget.alignment == Alignment.centerLeft) {
      return Alignment.centerLeft;
    }
    return Alignment.bottomCenter;
  }

  @override
  void dispose() {
    _closePopover();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(onTap: _togglePopover, child: widget.trigger),
    );
  }
}
