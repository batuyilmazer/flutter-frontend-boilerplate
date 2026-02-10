import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A themed calendar month view.
///
/// Wraps Flutter's [CalendarDatePicker] with consistent theme styling.
///
/// ```dart
/// AppCalendar(
///   initialDate: DateTime.now(),
///   onDateChanged: (date) => setState(() => _date = date),
/// )
/// ```
class AppCalendar extends StatelessWidget {
  const AppCalendar({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.currentDate,
    this.onDateChanged,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
  });

  /// Initially selected date. Defaults to today.
  final DateTime? initialDate;

  /// Earliest selectable date. Defaults to 10 years ago.
  final DateTime? firstDate;

  /// Latest selectable date. Defaults to 10 years from now.
  final DateTime? lastDate;

  /// The current date (highlighted). Defaults to today.
  final DateTime? currentDate;

  /// Called when a date is selected.
  final ValueChanged<DateTime>? onDateChanged;

  /// Called when the displayed month changes.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// Predicate to determine which days are selectable.
  final bool Function(DateTime)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = context.appRadius;

    final now = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius.calendar),
        border: Border.all(color: colors.border),
      ),
      child: CalendarDatePicker(
        initialDate: initialDate ?? now,
        firstDate: firstDate ?? DateTime(now.year - 10),
        lastDate: lastDate ?? DateTime(now.year + 10),
        currentDate: currentDate,
        onDateChanged: onDateChanged ?? (_) {},
        onDisplayedMonthChanged: onDisplayedMonthChanged,
        selectableDayPredicate: selectableDayPredicate,
      ),
    );
  }
}
