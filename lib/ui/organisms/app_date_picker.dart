import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed date picker that wraps Flutter's [showDatePicker].
///
/// The picker inherits theme tokens from [ThemeBuilder] (Material date picker
/// theme is already configured). This widget provides a convenient tap-to-pick
/// UI with a text field display.
///
/// ```dart
/// AppDatePicker(
///   initialDate: DateTime.now(),
///   firstDate: DateTime(2020),
///   lastDate: DateTime(2030),
///   onChanged: (date) => setState(() => _selectedDate = date),
/// )
/// ```
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.label,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.dateFormat,
  });

  /// Initial selected date. Defaults to now.
  final DateTime? initialDate;

  /// Earliest selectable date. Defaults to 100 years ago.
  final DateTime? firstDate;

  /// Latest selectable date. Defaults to 100 years from now.
  final DateTime? lastDate;

  /// Called when a date is selected.
  final ValueChanged<DateTime>? onChanged;

  /// Optional label displayed above the field.
  final String? label;

  /// Placeholder text.
  final String? hint;

  /// Whether to show a required indicator.
  final bool isRequired;

  /// Whether the field is interactive.
  final bool enabled;

  /// Custom date formatter. Defaults to yyyy-MM-dd.
  final String Function(DateTime)? dateFormat;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String _formatDate(DateTime date) {
    if (widget.dateFormat != null) return widget.dateFormat!(date);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate ?? now,
      firstDate: widget.firstDate ?? DateTime(now.year - 100),
      lastDate: widget.lastDate ?? DateTime(now.year + 100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    final field = GestureDetector(
      onTap: widget.enabled ? _pickDate : null,
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: widget.hint ?? 'Select a date',
          suffixIcon: Icon(
            Icons.calendar_today,
            color: colors.textSecondary,
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.medium),
            borderSide: BorderSide(color: colors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.medium),
            borderSide: BorderSide(color: colors.border),
          ),
          filled: true,
          fillColor: widget.enabled ? colors.surface : colors.disabled,
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.s12,
            vertical: spacing.s12,
          ),
        ),
        child: _selectedDate != null
            ? Text(
                _formatDate(_selectedDate!),
                style: typography.body.copyWith(color: colors.textPrimary),
              )
            : null,
      ),
    );

    if (widget.label == null) return field;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label!,
              style: typography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: typography.bodySmall.copyWith(color: colors.error),
              ),
          ],
        ),
        SizedBox(height: spacing.s6),
        field,
      ],
    );
  }
}
