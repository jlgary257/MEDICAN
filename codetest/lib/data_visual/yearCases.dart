import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

Future<Map<int, int>> fetchData() async {
  CollectionReference traumaCollection = FirebaseFirestore.instance
      .collection('MedicalCondition')
      .doc('5') // Replace with the actual document ID if needed
      .collection('Trauma');

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
  final DateFormat format = DateFormat('dd-MMM-yyyy');
  return format.parse(dateString);
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
                //.sort((a, b) => a.length.compareTo(b.length));
                const TextStyle(
                  color: Colors.black,
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
          show: true,
        ),
        barGroups: _getBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    List<MapEntry<int,int>> sortedEntries = data.entries.toList()..sort((a,b) => a.key.compareTo(b.key));
    return sortedEntries.map((entry) => BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.red,
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
    return Scaffold(
        appBar: MainAppBar(
          title: 'Cases vs. Years',
        ),
        body: GridView.count( crossAxisCount: 2, children: [ Container(
          child: FutureBuilder(
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
        ),Container(color: Colors.greenAccent,),
          Container(color: Colors.blue,child: FutureBuilder(
            future: fetchData(),
          builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CasesLineChart(data: snapshot.data as Map<int,int>),
              );
              }
            }
        ),),
          Container(color: Colors.green,),])
      );
  }
}

class CasesLineChart extends StatefulWidget {
  final Map<int,int> data;

  CasesLineChart({required this.data});
  @override
  _CasesLineChartState createState() => _CasesLineChartState();
}

class _CasesLineChartState extends State<CasesLineChart> {
  //final Map<int,int> data;
  List<FlSpot> spot = [];

  @override
  void initState() {
    super.initState();
    loadChartData();
  }

  loadChartData() {
    List<MapEntry<int,int>> sortedEntries = widget.data.entries.toList()..sort((a,b) => a.key.compareTo(b.key));
    List<FlSpot> dataPoints = sortedEntries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
    setState(() {

        spot = dataPoints;

    });
  }

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
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spot,
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