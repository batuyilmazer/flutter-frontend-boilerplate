import 'package:flutter/material.dart';
import '../../theme/extensions/theme_context_extensions.dart';

/// A data point for simple chart rendering.
class AppChartDataPoint {
  const AppChartDataPoint({
    required this.label,
    required this.value,
    this.color,
  });

  /// Label for this data point.
  final String label;

  /// Numeric value.
  final double value;

  /// Optional color override for this point.
  final Color? color;
}

/// Chart display type.
enum AppChartType { bar, horizontalBar }

/// A simple themed bar chart.
///
/// For advanced charting, consider adding the `fl_chart` package.
///
/// ```dart
/// AppChart(
///   data: [
///     AppChartDataPoint(label: 'Jan', value: 30),
///     AppChartDataPoint(label: 'Feb', value: 50),
///     AppChartDataPoint(label: 'Mar', value: 20),
///   ],
/// )
/// ```
class AppChart extends StatelessWidget {
  const AppChart({
    super.key,
    required this.data,
    this.type = AppChartType.bar,
    this.height = 200,
    this.barWidth,
    this.showLabels = true,
    this.showValues = false,
    this.color,
  });

  /// Chart data points.
  final List<AppChartDataPoint> data;

  /// Chart type. Defaults to vertical bar.
  final AppChartType type;

  /// Chart height. Defaults to 200.
  final double height;

  /// Individual bar width. Auto-calculated if null.
  final double? barWidth;

  /// Whether to show labels below bars.
  final bool showLabels;

  /// Whether to show value text above bars.
  final bool showValues;

  /// Default bar color. Defaults to primary.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final spacing = context.appSpacing;
    final radius = context.appRadius;
    final typography = context.appTypography;

    if (data.isEmpty) return SizedBox(height: height);

    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final defaultColor = color ?? colors.primary;

    if (type == AppChartType.horizontalBar) {
      return _buildHorizontalBars(
        context,
        maxVal,
        defaultColor,
        colors,
        spacing,
        radius,
        typography,
      );
    }

    return _buildVerticalBars(
      context,
      maxVal,
      defaultColor,
      colors,
      spacing,
      radius,
      typography,
    );
  }

  Widget _buildVerticalBars(
    BuildContext context,
    double maxVal,
    Color defaultColor,
    dynamic colors,
    dynamic spacing,
    dynamic radius,
    dynamic typography,
  ) {
    final appColors = context.appColors;
    final appSpacing = context.appSpacing;
    final appRadius = context.appRadius;
    final appTypography = context.appTypography;

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((point) {
          final ratio = maxVal > 0 ? point.value / maxVal : 0.0;
          final barHeight =
              ratio * (height - (showLabels ? 30 : 0) - (showValues ? 20 : 0));
          final barColor = point.color ?? defaultColor;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appSpacing.s2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showValues)
                    Padding(
                      padding: EdgeInsets.only(bottom: appSpacing.s2),
                      child: Text(
                        point.value.toStringAsFixed(0),
                        style: appTypography.caption.copyWith(
                          color: appColors.textSecondary,
                        ),
                      ),
                    ),
                  Container(
                    height: barHeight.clamp(2.0, double.infinity),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(appRadius.small),
                      ),
                    ),
                  ),
                  if (showLabels)
                    Padding(
                      padding: EdgeInsets.only(top: appSpacing.s4),
                      child: Text(
                        point.label,
                        style: appTypography.caption.copyWith(
                          color: appColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalBars(
    BuildContext context,
    double maxVal,
    Color defaultColor,
    dynamic colors,
    dynamic spacing,
    dynamic radius,
    dynamic typography,
  ) {
    final appColors = context.appColors;
    final appSpacing = context.appSpacing;
    final appRadius = context.appRadius;
    final appTypography = context.appTypography;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: data.map((point) {
        final ratio = maxVal > 0 ? point.value / maxVal : 0.0;
        final barColor = point.color ?? defaultColor;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: appSpacing.s4),
          child: Row(
            children: [
              if (showLabels)
                SizedBox(
                  width: 60,
                  child: Text(
                    point.label,
                    style: appTypography.caption.copyWith(
                      color: appColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (showLabels) SizedBox(width: appSpacing.s8),
              Expanded(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ratio.clamp(0.02, 1.0),
                  child: Container(
                    height: barWidth ?? 20,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(appRadius.small),
                      ),
                    ),
                  ),
                ),
              ),
              if (showValues) ...[
                SizedBox(width: appSpacing.s8),
                Text(
                  point.value.toStringAsFixed(0),
                  style: appTypography.caption.copyWith(
                    color: appColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
