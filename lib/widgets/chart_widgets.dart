import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> values;

  const WeeklyBarChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          barGroups: List.generate(values.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  color: AppColors.primary,
                  width: 16,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class MoodDonutChart extends StatelessWidget {
  final double percent;

  const MoodDonutChart({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
              value: percent,
              color: AppColors.primary,
              showTitle: false,
            ),
            PieChartSectionData(
              value: 100 - percent,
              color: Colors.grey.shade200,
              showTitle: false,
            ),
          ],
        ),
      ),
    );
  }
}