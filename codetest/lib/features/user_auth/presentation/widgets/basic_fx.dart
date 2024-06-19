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

void showDeleteConfirmation(BuildContext context, Function onDelete) async {
  final confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this item?"),
        actions: <Widget>[
          TextButton(
            child: Text("CANCEL"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("DELETE"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    onDelete(); // Call the passed delete function if confirmed
  }
}
