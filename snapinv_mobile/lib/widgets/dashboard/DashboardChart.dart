import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 225,
      // width: 300, // Adjust to your layout
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, _) {
                  switch (value.toInt()) {
                    case 0:
                      return Text('A');
                    case 1:
                      return Text('B');
                    case 2:
                      return Text('C');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: 12, color: Colors.blue, width: 18),
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: 8, color: Colors.green, width: 18),
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: 4, color: Colors.red, width: 18),
            ]),
          ],
        ),
      ),
    );
  }
}
