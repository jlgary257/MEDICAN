import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';
import '../features/user_auth/presentation/pages/login_page.dart'; // Ensure this import is correct for the login page

class DrForm extends StatefulWidget {
  const DrForm({super.key});

  @override
  State<DrForm> createState() => _DrFormState();
}

class _DrFormState extends State<DrForm> {
  TextEditingController _patIdController = TextEditingController();
  TextEditingController _diagnoseController = TextEditingController();
  TextEditingController _transferController = TextEditingController();
  TextEditingController _medCondController = TextEditingController();
  TextEditingController _drController = TextEditingController();

  void dispose(){
    this._diagnoseController;
    this._drController;
    this._transferController;
    this._medCondController;
    this._patIdController;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor"), // Keeping MainAppBar as requested
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
            FormContainerWidget(
              controller: _diagnoseController,
              hintText: "Diagnose",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _transferController,
              hintText: "Transfer to",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            
            FormContainerWidget(
              controller: _drController,
              hintText: "Doctor",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _patIdController,
              hintText: "PatientID",
              isPasswordField: false,
            ),
            SizedBox(height: 30),
            RedElevatedButton(onPressed: _addMedReport, text: "Diagnose"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addMedReport() async {
    String diagnosis = _diagnoseController.text;
    String transferTo = _transferController.text;
    String MedConditionID = _medCondController.text;
    String doctorID = _drController.text;
    String patientID = _patIdController.text;

    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    final MedRepCollection = FirebaseFirestore.instance.collection("MedicalCondition").doc().collection("MedicalReport");
    String id = MedRepCollection.doc().id;

    final newMedRep = MedRepModel(
      ID: id,
      date: formattedDate,
      time: formattedTime,
      diagnose: diagnosis,
      TransferTo: transferTo,
      DoctorID: doctorID,
      PatientID: patientID,
    ).toJson();

    try {
          await MedRepCollection.doc(id).set(newMedRep);

          if (newMedRep != null){
            showToast(message: "Added MedRep successfully");
            Navigator.pushAndRemoveUntil(context as BuildContext, MaterialPageRoute(builder: (context) => homeDoctor()),(route) => false);
          }

    } on Exception catch (e) {
      print("Error :  ${e}");
    }
  }
}

class MedRepModel {
  final String? ID;
  final String? date;
  final String? time;
  final String? diagnose;
  final String? MedConditionId;
  final String? TransferTo;
  final String? DoctorID;
  final String? PatientID;

  MedRepModel({
    this.ID,
    this.date,
    this.time,
    this.diagnose,
    this.MedConditionId,
    this.TransferTo,
    this.DoctorID,
    this.PatientID,
  });

  static MedRepModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return MedRepModel(
      ID: snapshot['ID'],
      date: snapshot['date'],
      time: snapshot['time'],
      diagnose: snapshot['diagnose'],
      MedConditionId: snapshot['MedConditionId'],
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
      "MedConditionId": MedConditionId,
      "TransferTo": TransferTo,
      "DoctorID": DoctorID,
      "PatientID": PatientID,
    };
  }
}
