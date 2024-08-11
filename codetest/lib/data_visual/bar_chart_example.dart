import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class BarExample extends StatefulWidget {
  const BarExample({super.key});

  @override
  State<BarExample> createState() => _BarExample();
}

class _BarExample extends State<BarExample> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Charts Example'),
        ),
        body: SingleChildScrollView( // Enables scrolling if charts overflow the screen size
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: CasesBarChart(),
              ),
              CasesLineChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class CasesBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio( // Maintains an aspect ratio for the chart
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
             // tooltipBgColor: Colors.blueAccent.withOpacity(0.8),
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: defaultGetTitle,
                reservedSize: 34,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: defaultGetTitle,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 8,
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 14,
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 15,
                  color: Colors.blue,
                  width: 15,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CasesLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: defaultGetTitle,
                reservedSize: 34,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: defaultGetTitle,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 5),
                FlSpot(3, 6),
              ],
              isCurved: true,
              barWidth: 2,
              color: Colors.red,
              belowBarData: BarAreaData(show: true),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}

Widget defaultGetTitle(double value, TitleMeta meta) {
  Widget text = Text(
    value.toString(),
    style: TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16, // You can change the space from the axis here
    child: text,
  );
}