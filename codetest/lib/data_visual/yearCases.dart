import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Future<Map<int, int>> fetchData() async {
  // Reference to the trauma subcollection
  CollectionReference traumaCollection = FirebaseFirestore.instance
      .collection('medicalCondition')
      .doc('trauma') // Replace with the actual document ID if needed
      .collection('trauma');

  QuerySnapshot snapshot = await traumaCollection.get();

  // Map to store year as key and count of cases as value
  Map<int, int> casesPerYear = {};

  for (var doc in snapshot.docs) {
    String dateString = doc['date']; // Assuming there's a 'date' field
    DateTime date = _parseDate(dateString);
    int year = date.year;

    casesPerYear.update(year, (value) => value + 1, ifAbsent: () => 1);
  }

  return casesPerYear;
}

// Helper function to parse the date string
DateTime _parseDate(String dateString) {
  return DateTime.parse(dateString.replaceAll('-', ' '));
}

class CasesBarChart extends StatelessWidget {
  final Map<int, int> data;

  CasesBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            //tooltipBgColor: Colors.blueAccent.withOpacity(0.8), // Tooltip background
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final double value = rod.toY; // Get the correct value
              return BarTooltipItem(
                'Year: ${group.x.toInt()}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Cases: $value',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: _getBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return data.entries
        .map(
          (entry) => BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    )
        .toList();
  }

  double _getMaxY() {
    return data.values.reduce((a, b) => a > b ? a : b).toDouble() + 5;
  }
}


class TraumaCase extends StatefulWidget {
  const TraumaCase({super.key});

  @override
  State<TraumaCase> createState() => _traumaCase();
}

class _traumaCase extends State<TraumaCase> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Cases vs. Years'),
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CasesBarChart(snapshot.data as Map<int, int>),
              );
            }
          },
        ),
      ),
    );
  }
}
