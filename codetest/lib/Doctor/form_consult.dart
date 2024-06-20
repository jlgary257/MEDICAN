import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? _selectedMedCondition;
  String? _doctorId;

  @override
  void dispose() {
    _patIdController.dispose();
    _diagnoseController.dispose();
    _transferController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDoctorId();
  }

  Future<void> _fetchDoctorId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      if (email.isNotEmpty) {
        String? doctorId = await getDoctorIdByEmail(email);
        setState(() {
          _doctorId = doctorId;
        });
      }
    }
  }

  Future<String?> getDoctorIdByEmail(String email) async {
    try {
      final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");
      final doctorQuerySnapshot = await doctorCollection.where('email', isEqualTo: email).get();

      if (doctorQuerySnapshot.docs.isNotEmpty) {
        return doctorQuerySnapshot.docs[0].id; // Return the document ID as the Doctor ID
      }

      return null; // Doctor ID not found
    } catch (error) {
      print('Error getting doctor ID: $error');
      return null; // Handle potential errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor"), // Using AppBar instead of MainAppBar for simplicity
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              controller: _patIdController,
              hintText: "PatientID",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
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
                  child: Text("Common Cases/Others"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMedCondition = value;
                });
              },
            ),
            SizedBox(height: 30),
            RedElevatedButton(onPressed: _addMedReport, text: "Diagnose"), // Ensure RedElevatedButton is correctly defined or use ElevatedButton as placeholder
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addMedReport() async {
    String diagnosis = _diagnoseController.text;
    String transferTo = _transferController.text;
    String? doctorID = _doctorId;
    String patientID = _patIdController.text;
    String medConditionId = _selectedMedCondition ?? "";

    if (medConditionId.isEmpty) {
      showToast(message: "Please select a medical condition");
      return;
    }

    final DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    CollectionReference medRepCollection;

    if (medConditionId == "1") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Respiratory Infection");
    } else if (medConditionId == "2") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Parasite Infection");
    } else if (medConditionId == "3") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Lumps and Bumps");
    } else if (medConditionId == "4") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Gastrointestinal Disease");
    } else if (medConditionId == "5") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Trauma");
    } else if (medConditionId == "6") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Covid-19");
    } else {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Common Cases/Others");
    }

    String id = medRepCollection.doc().id;

    final newMedRep = MedRepModel(
      ID: id,
      date: formattedDate,
      time: formattedTime,
      diagnose: diagnosis,
      MedConditionId: medConditionId,
      TransferTo: transferTo,
      DoctorID: doctorID,
      PatientID: patientID,
    ).toJson();

    try {
      await medRepCollection.doc(id).set(newMedRep);

      if (newMedRep != null) {
        showToast(message: "Added MedRep successfully");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => homeDoctor()),
              (route) => false,
        );
      }
    } on Exception catch (e) {
      print("Error: ${e}");
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

  static MedRepModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
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
