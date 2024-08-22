import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/form_consult.dart';
import 'package:codetest/features/user_auth/presentation/widgets/basic_fx.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class viewPatientInfo extends StatefulWidget {
  const viewPatientInfo({super.key});

  @override
  State<viewPatientInfo> createState() => _viewPatientInfoState();
}

class _viewPatientInfoState extends State<viewPatientInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Medican",),
      body:  TabulateData()
    );
  }
}

class UpdatePatientInfo extends StatefulWidget {
  final String documentId; // Pass the document ID

  const UpdatePatientInfo({super.key, required this.documentId});

  @override
  State<UpdatePatientInfo> createState() => _UpdatePatientInfoState();
}

class _UpdatePatientInfoState extends State<UpdatePatientInfo> {
  final TextEditingController _patController = TextEditingController();
  final TextEditingController _diagnoseController = TextEditingController();
  final TextEditingController _transferController = TextEditingController();
  final TextEditingController _drController = TextEditingController();
  final TextEditingController _patTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the widget is initialized
  }

  Future<void> _loadData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Admission')
        .doc(widget.documentId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      setState(() {
        _patController.text = data['PatientID'] ?? '';
        _diagnoseController.text = data['diagnose'] ?? '';
        _transferController.text = data['TransferTo'] ?? '';
        _drController.text = data['DoctorID'] ?? '';
        _patTypeController.text = data['PatientType'] ?? '';
      });
    }
  }

  void _updatePatientData() {
    final admissionCollection =
    FirebaseFirestore.instance.collection("Admission");

    final newAdmission = {
      'PatientID': _patController.text,
      'diagnose': _diagnoseController.text,
      'TransferTo': _transferController.text,
      'DoctorID': _drController.text,
      'PatientType': _patTypeController.text,
      'date': DateTime.now().toIso8601String(), // Update with current date
      'time': TimeOfDay.now().format(context),  // Update with current time
    };

    admissionCollection.doc(widget.documentId).update(newAdmission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medican")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Patient Medical Report",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _diagnoseController,
              decoration: InputDecoration(hintText: "Diagnose"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _transferController,
              decoration: InputDecoration(hintText: "Transfer to"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _patTypeController,
              decoration: InputDecoration(hintText: "Patient Type"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _drController,
              decoration: InputDecoration(hintText: "Doctor"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _patController,
              decoration: InputDecoration(hintText: "PatientID"),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _updatePatientData,
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AdmissionModel {
  final String? ID;
  final String? date;
  final String? time;
  final String? diagnose;
  final String? PatientType;
  final String? TransferTo;
  final String? DoctorID;
  final String? PatientID;

  AdmissionModel({
    this.ID,
    this.date,
    this.time,
    this.diagnose,
    this.PatientType,
    this.TransferTo,
    this.DoctorID,
    this.PatientID,
  });

  static AdmissionModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AdmissionModel(
      ID: snapshot['ID'],
      date: snapshot['date'],
      time: snapshot['time'],
      diagnose: snapshot['diagnose'],
      PatientType: snapshot['PatientType'],
      TransferTo: snapshot['TransferTo'],
      DoctorID: snapshot['DoctorID'],
      PatientID: snapshot['PatientID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": ID,
      "date": date,
      "time": time,
      "diagnose": diagnose,
      "PatientType": PatientType,
      "TransferTo": TransferTo,
      "DoctorID": DoctorID,
      "PatientID": PatientID,
    };
  }
}
