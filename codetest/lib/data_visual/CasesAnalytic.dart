import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CasesAnalytic extends StatefulWidget {
  const CasesAnalytic({super.key});

  @override
  State<CasesAnalytic> createState() => _CasesAnalyticState();
}

class _CasesAnalyticState extends State<CasesAnalytic> {
  String? _selectedMedCondition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          title: 'Case Analytics',
        ),
        body: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMedCondition,
              hint: Text("Select Medical Condition"),
              items: [
                DropdownMenuItem(
                  value: "1",
                  child: Text("Respiratory Infection"),
                ),
                DropdownMenuItem(
                  value: "2",
                  child: Text("Parasite Infection"),
                ),
                DropdownMenuItem(
                  value: "3",
                  child: Text("Lumps and Bumps"),
                ),
                DropdownMenuItem(
                  value: "4",
                  child: Text("Gastrointestinal Disease"),
                ),
                DropdownMenuItem(
                  value: "5",
                  child: Text("Trauma"),
                ),
                DropdownMenuItem(
                  value: "6",
                  child: Text("Covid-19"),
                ),
                DropdownMenuItem(
                  value: "7",
                  child: Text("Common Cases and Others"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMedCondition = value;
                });
              },
            ),
            Expanded(
              child: GridView.count(crossAxisCount: 2, children: [
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
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
                ),
                Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
                    child: FutureBuilder(
                  future: fetchCaseCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HighDiagnose(totalCases: snapshot.data ?? 0),
                      );
                    } else {
                      return Center(child: Text('No data availabale'));
                    }
                  },
                )),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
                  child: FutureBuilder(
                      future: fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CasesLineChart(
                                data: snapshot.data as Map<int, int>),
                          );
                        }
                      }),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2)),
                ),
              ]),
            ),
          ],
        ));
  }

  Future<int> fetchCaseCount() async {
    CollectionReference medRepCollection;

    if (_selectedMedCondition == "1") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Respiratory_Infection");
    } else if (_selectedMedCondition == "2") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Parasite_Infection");
    } else if (_selectedMedCondition == "3") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Lumps_and_Bumps");
    } else if (_selectedMedCondition == "4") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Gastrointestinal_Disease");
    } else if (_selectedMedCondition == "5") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Trauma");
    } else if (_selectedMedCondition == "6") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Covid-19");
    } else if (_selectedMedCondition == "7") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Common_Cases_and_Others");
    } else {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Extra");
    }

    QuerySnapshot snapshot = await medRepCollection.get();

    return snapshot.size;
  }

  Future<Map<int, int>> fetchData() async {
    CollectionReference medRepCollection;

    if (_selectedMedCondition == "1") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Respiratory_Infection");
    } else if (_selectedMedCondition == "2") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Parasite_Infection");
    } else if (_selectedMedCondition == "3") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Lumps_and_Bumps");
    } else if (_selectedMedCondition == "4") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Gastrointestinal_Disease");
    } else if (_selectedMedCondition == "5") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Trauma");
    } else if (_selectedMedCondition == "6") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Covid-19");
    } else if (_selectedMedCondition == "7") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Common_Cases_and_Others");
    } else {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(_selectedMedCondition)
          .collection("Extra");
    }

    QuerySnapshot snapshot = await medRepCollection.get();

    // Map to store year as key and count of cases as value
    Map<int, int> casesPerYear = {};

    for (var doc in snapshot.docs) {
      String dateString = doc['date']; // Assuming there's a 'date' field
      DateTime date = _parseDate(dateString);
      int year = date.month;

      casesPerYear.update(year, (value) => value + 1, ifAbsent: () => 1);
    }

    return casesPerYear;
  }
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
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
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
    List<MapEntry<int, int>> sortedEntries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sortedEntries
        .map(
          (entry) => BarChartGroupData(
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

class CasesLineChart extends StatefulWidget {
  final Map<int, int> data;

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
    List<MapEntry<int, int>> sortedEntries = widget.data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    List<FlSpot> dataPoints = sortedEntries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
    setState(() {
      spot = dataPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (spot.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
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

class HighDiagnose extends StatefulWidget {
  final int totalCases;

  const HighDiagnose({required this.totalCases});

  @override
  State<HighDiagnose> createState() => _HighDiagnoseState();
}

class _HighDiagnoseState extends State<HighDiagnose>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  //int _totalCases = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = IntTween(begin: 0, end: widget.totalCases).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    // Start the animation
    _controller.forward();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Centers the content vertically
        children: [
          Text(
            'Total Cases',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10), // Adds spacing between the title and the box
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              '${_animation.value}',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
