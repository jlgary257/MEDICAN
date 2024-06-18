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
  //TextEditingController _IDController = TextEditingController();
  TextEditingController _patController = TextEditingController();
  TextEditingController _diagnoseController = TextEditingController();
  TextEditingController _transferController = TextEditingController();
  TextEditingController _drController = TextEditingController();
  TextEditingController _patTypeController = TextEditingController();

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
              controller: _patTypeController,
              hintText: "Patient Type",
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
              controller: _patController,
              hintText: "PatientID",
              isPasswordField: false,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                  _addPatientData();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Diagnose",
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

  void _addPatientData() async {
    String diagnosis = _diagnoseController.text;
    String transferTo = _transferController.text;
    String patType = _patTypeController.text;
    String doctorID = _drController.text;
    String patientID = _patController.text;

    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    final admissionCollection = FirebaseFirestore.instance.collection("Admission");
    String id = admissionCollection.doc().id;

    final newAdmission = AdmissionModel(
      ID: id,
      date: formattedDate,
      time: formattedTime,
      diagnose: diagnosis,
      TransferTo: transferTo,
      PatientType: patType,
      DoctorID: doctorID,
      PatientID: patientID,
    ).toJson();

    try {
          await admissionCollection.doc(id).set(newAdmission);

          if (newAdmission != null){
            showToast(message: "Added Admission successfully");
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homeDoctor()),(route) => false);
          }

    } on Exception catch (e) {
      print("Error :  ${e}");
    }
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
