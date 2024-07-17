import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class TabulateData extends StatefulWidget {
  const TabulateData({super.key});

  @override
  State<TabulateData> createState() => _TabulateDataState();
}

class _TabulateDataState extends State<TabulateData> {
  late Future<List<Patient>> _patientList;

  @override
  void initState() {
    super.initState();
    _patientList = fetchPatients();
  }

  Future<List<Patient>> fetchPatients() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Patients')
          .orderBy('IC',  descending: false)
          .orderBy('name', descending: true)
          .orderBy('gender', descending: false)
          .limit(100)
          .get();


      if (snapshot.docs.isEmpty) {
        print('No documents found');
        return [];
      }

      return snapshot.docs.asMap().entries.map((entry) {
        int index = entry.key;
        DocumentSnapshot doc = entry.value;
        return Patient.fromSnapshot(doc, index);
      }).toList();
    } catch (e) {
      print('Error fetching patients: $e');
      return []; // Handle error gracefully
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home",),
      body: FutureBuilder<List<Patient>>(
        future: _patientList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final patients = snapshot.data!;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return Card(
                child: ListTile(
                  leading: Text('#${index + 1}'),
                  title: Text(patient.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IC: ${patient.ic}'),
                      Text('Gender: ${patient.gender}'),
                      //Text('phoneNo: ${patient.phoneNo}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Patient {

  final String id;
  final String ic;
  final String name;
  final String gender;
  //final String phoneNo;

  Patient({
    required this.id,
    required this.ic,
    required this.name,
    required this.gender,
   // required this.phoneNo,
  });

  factory Patient.fromSnapshot(DocumentSnapshot doc, int index) {
    final data = doc.data() as Map<String, dynamic>;
    return Patient(
      id: doc.id,
      ic: data['ic'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      //phoneNo: data['phoneNo'] ?? '',
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
