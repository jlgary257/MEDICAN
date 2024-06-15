import 'package:flutter/material.dart';

class TabulateData extends StatefulWidget {
  const TabulateData({super.key});

  @override
  State<TabulateData> createState() => _TabulateDataState();
}

class _TabulateDataState extends State<TabulateData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                ],
                rows: List.generate(
                  100, // Ensure there are enough rows to require scrolling
                      (index) => DataRow(
                    cells: [
                      DataCell(Text('Cell ${index + 1}')),
                      DataCell(Text('Cell ${index + 1}')),
                      DataCell(Text('Cell ${index + 1}')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


