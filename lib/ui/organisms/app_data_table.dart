import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A column definition for [AppDataTable].
class AppDataColumn {
  const AppDataColumn({
    required this.label,
    this.numeric = false,
    this.sortable = false,
    this.width,
  });

  /// Column header label.
  final String label;

  /// Whether this column contains numeric data (right-aligned).
  final bool numeric;

  /// Whether this column supports sorting.
  final bool sortable;

  /// Optional fixed width.
  final double? width;
}

/// A row definition for [AppDataTable].
class AppDataRow {
  const AppDataRow({required this.cells, this.selected = false, this.onTap});

  /// The cell values for this row.
  final List<Widget> cells;

  /// Whether this row is selected.
  final bool selected;

  /// Optional tap handler for this row.
  final VoidCallback? onTap;
}

/// A themed data table with sorting and selection support.
///
/// ```dart
/// AppDataTable(
///   columns: [
///     AppDataColumn(label: 'Name'),
///     AppDataColumn(label: 'Age', numeric: true, sortable: true),
///   ],
///   rows: [
///     AppDataRow(cells: [Text('Alice'), Text('30')]),
///     AppDataRow(cells: [Text('Bob'), Text('25')]),
///   ],
/// )
/// ```
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.showCheckboxColumn = false,
    this.onSelectAll,
  });

  /// Column definitions.
  final List<AppDataColumn> columns;

  /// Row definitions.
  final List<AppDataRow> rows;

  /// Currently sorted column index.
  final int? sortColumnIndex;

  /// Sort direction.
  final bool sortAscending;

  /// Called when a sortable column header is tapped.
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Whether to show a checkbox column for selection.
  final bool showCheckboxColumn;

  /// Called when select-all checkbox is toggled.
  final ValueChanged<bool?>? onSelectAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final typography = context.appTypography;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        showCheckboxColumn: showCheckboxColumn,
        headingRowColor: WidgetStateProperty.all(colors.surfaceVariant),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withValues(alpha: 0.08);
          }
          return colors.surface;
        }),
        dividerThickness: 1,
        horizontalMargin: spacing.s16,
        columnSpacing: spacing.s24,
        headingTextStyle: typography.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        dataTextStyle: typography.body.copyWith(color: colors.textPrimary),
        columns: columns.asMap().entries.map((entry) {
          final col = entry.value;
          return DataColumn(
            label: Text(col.label),
            numeric: col.numeric,
            onSort: col.sortable && onSort != null
                ? (colIndex, ascending) => onSort!(colIndex, ascending)
                : null,
          );
        }).toList(),
        rows: rows.map((row) {
          return DataRow(
            selected: row.selected,
            onSelectChanged: showCheckboxColumn
                ? (selected) => row.onTap?.call()
                : null,
            cells: row.cells.map((cell) => DataCell(cell)).toList(),
          );
        }).toList(),
      ),
    );
  }
}
