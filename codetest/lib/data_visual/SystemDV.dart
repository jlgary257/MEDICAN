import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SystemDataV extends StatefulWidget {
  const SystemDataV({super.key});

  @override
  State<SystemDataV> createState() => _SystemDataVState();
}

class _SystemDataVState extends State<SystemDataV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(title: 'Medican'),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            Container(
              child: FutureBuilder(
                future: fetchDoctorCaseData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          DoctorCaseBarChart(snapshot.data as Map<String, int>),
                    );
                  }
                },
              ),
            ),
            Container(
              color: Colors.blueAccent,
            )
          ],
        ));
  }

  Future<Map<String, String>> _fetchDoctorNames(List<String> emails) async {
    Map<String, String> doctorNames = {};

    for (String email in emails) {
      String? name = await getNamebyEmail(email);
      if (name != null) {
        doctorNames[email] = name;
      }
    }

    return doctorNames;
  }

  Future<Map<String, int>> fetchDoctorCaseData() async {
    final firestore = FirebaseFirestore.instance;
    Set<String> emails = {};
    final List<String> medicalCondition = [
      "Respiratory_Infection",
      "Parasite_Infection",
      "Lumps_and_Bumps",
      "Gastrointestinal_Disease",
      "Trauma",
      "Covid-19",
      "Common_Cases_and_Others"
    ];

    Map<String, int> doctorCases = {};
    for (int num = 1; num <= 7; num++) {
      for (String condition in medicalCondition) {
        CollectionReference medConCollection = firestore
            .collection("MedicalCondition")
            .doc(num.toString())
            .collection(condition);


        QuerySnapshot snapshot = await medConCollection.get();

        for (var doc in snapshot.docs) {
          String doctorEmail = doc['DoctorEmail'];
          emails.add(doctorEmail);

          if (doctorCases.containsKey(doctorEmail)) {
            doctorCases[doctorEmail] = doctorCases[doctorEmail]! + 1;
          } else {
            doctorCases[doctorEmail] = 1;
          }
        }
      }
    }

    // Fetch and cache doctor names
    Map<String, String> doctorNames = await _fetchDoctorNames(emails.toList());

    // Map emails to names for chart data
    Map<String, int> namedDoctorCases = {};
    doctorCases.forEach((email, count) {
      String? name = doctorNames[email];
      if (name != null) {
        namedDoctorCases[name] = count;
      }
    });

    return namedDoctorCases;
  }
}

Future<String?> getNamebyEmail(String DoctorEmail) async {
  try {
    final doctorSnapshot = await FirebaseFirestore.instance
        .collection("Staff")
        .doc("2")
        .collection("Doctor")
        .where('email', isEqualTo: DoctorEmail)
        .get();

    if (doctorSnapshot.docs.isNotEmpty) {
      return doctorSnapshot.docs[0].data()['name'] as String?;
    }

    return null;
  } catch (error) {
    print('Error: $error');
    return null;
  }
}

class DoctorCaseBarChart extends StatelessWidget {
  final Map<String, int> data;

  DoctorCaseBarChart(this.data);

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
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final double value = rod.toY;
              final String doctorName = data.keys
                  .toList()[group.x.toInt()]; // Get doctor email by index
              return BarTooltipItem(
                'Doctor: $doctorName\n',
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
              getTitlesWidget: (value, meta) {
                final String doctorEmail = data.keys
                    .toList()[value.toInt()]; // Get doctor email by index
                return Text(
                  doctorEmail,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10, // Adjust font size to fit
                  ),
                  overflow: TextOverflow.ellipsis, // Ellipsis for long emails
                );
              },
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
    List<MapEntry<String, int>> sortedEntries = data.entries.toList();

    return sortedEntries
        .asMap()
        .entries
        .map(
          (entry) => BarChartGroupData(
            x: entry.key, // Use index as x value
            barRods: [
              BarChartRodData(
                toY: entry.value.value.toDouble(),
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
