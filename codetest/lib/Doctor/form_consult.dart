import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html; // For accessing localStorage in Flutter Web
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DrForm extends StatefulWidget {
  const DrForm({super.key});

  @override
  State<DrForm> createState() => _DrFormState();
}

class _DrFormState extends State<DrForm> {
  TextEditingController _patIdController = TextEditingController();
  TextEditingController _diagnoseController = TextEditingController();
  String? _transferController;
  String? _selectedMedCondition;
  String? _doctorEmail;

  @override
  void dispose() {
    _patIdController.dispose();
    _diagnoseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDoctorEmail();
  }

  Future<void> _fetchDoctorEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _doctorEmail = user.email ?? '';
      });
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> findDiagnosis() async {
    String diagnosis = _diagnoseController.text;

    if (diagnosis.isEmpty) {
      showToast(
          message:
              "Please enter a diagnosis"); // Show a message if input is empty
      return;
    }

    try {
      // Send the POST request to the Flask server
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'diagnosis': diagnosis}),
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final data = jsonDecode(response.body);
        String predictedClass = data['predicted_class'];
        setState(() {
          // Map the prediction to the medical condition
          if (predictedClass == "Trauma ") {
            _selectedMedCondition = "5";
          } else if (predictedClass == "Lumps_and_Bumps") {
            _selectedMedCondition = "3";
          } else if (predictedClass == "Parasite_infection") {
            _selectedMedCondition = "2";
          } else if (predictedClass == "Respiratory_Infection") {
            _selectedMedCondition = "1";
          } else if (predictedClass == "Covid-19") {
            _selectedMedCondition = "6";
          } else if (predictedClass == "Common_cases") {
            _selectedMedCondition = "7";
          } else if (predictedClass == "Gastrointestinal_Disease") {
            _selectedMedCondition = "4";
          } else {
            _selectedMedCondition = null; // Handle unknown predictions
          }

          // Update the UI
        });

        showToast(message: "Predicted Medical Condition: $predictedClass");
      } else {
        showToast(message: "Error: Failed to get prediction");
      }
    } catch (e) {
      print("Error: $e");
      showToast(message: "Error: Could not connect to server");
    }
  }

  void _findMedicalCondition() {
    // Retrieve the predicted condition from localStorage
    final predictedCondition =
        html.window.localStorage['predictedMedicalCondition'];

    if (predictedCondition != null) {
      setState(() {
        // Map the predicted condition to the dropdown value
        if (predictedCondition == "Trauma") {
          _selectedMedCondition = "5";
        } else if (predictedCondition == "Lumps_and_Bumps") {
          _selectedMedCondition = "3";
        } else if (predictedCondition == "Parasite_Infection") {
          _selectedMedCondition = "2";
        } else if (predictedCondition == "Respiratory_Infection") {
          _selectedMedCondition = "1";
        } else if (predictedCondition == "Covid-19") {
          _selectedMedCondition = "6";
        } else if (predictedCondition == "Common_Cases") {
          _selectedMedCondition = "7";
        } else if (predictedCondition == "Gastrointestinal_Disease") {
          _selectedMedCondition = "4";
        } else {
          _selectedMedCondition = null; // If no match, reset the dropdown
        }
      });
    } else {
      showToast(message: "No predicted condition found. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Medican"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Patient Medical Report",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: FormContainerWidget(
                    controller: _diagnoseController,
                    hintText: "Diagnose",
                    isPasswordField: false,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: findDiagnosis,
                  child: Text('Find'),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _transferController,
              hint: Text("Select Medical where to Transer Patient"),
              items: [
                DropdownMenuItem(
                  value: "Oupaitent",
                  child: Text("Outpatient"),
                ),
                DropdownMenuItem(
                  value: "Emergency",
                  child: Text("Emergency"),
                ),
                DropdownMenuItem(
                  value: "Dental",
                  child: Text("Dental"),
                ),
                DropdownMenuItem(
                  value: "Medical Check-up",
                  child: Text("Medical Check-up"),
                ),
                DropdownMenuItem(
                  value: "Blood Taking",
                  child: Text("Blood Taking"),
                )
              ],
              onChanged: (value) {
                setState(() {
                  _transferController = value;
                });
              },
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
                  child: Text("Common Cases and Others"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMedCondition = value;
                });
              },
            ),
            SizedBox(height: 30),
            RedElevatedButton(
              onPressed: _addMedReport,
              text: "Diagnose",
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _addMedReport() async {
    String diagnosis = _diagnoseController.text;
    String transferTo = _transferController ?? "";
    String? doctorEmail = _doctorEmail;
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
          .collection("Respiratory_Infection");
    } else if (medConditionId == "2") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Parasite_Infection");
    } else if (medConditionId == "3") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Lumps_and_Bumps");
    } else if (medConditionId == "4") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Gastrointestinal_Disease");
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
    } else if (medConditionId == "7") {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Common_Cases_and_Others");
    } else {
      medRepCollection = FirebaseFirestore.instance
          .collection("MedicalCondition")
          .doc(medConditionId)
          .collection("Extra");
    }

    String id = medRepCollection.doc().id;

    final newMedRep = MedRepModel(
      date: formattedDate,
      time: formattedTime,
      diagnose: diagnosis,
      MedConditionId: medConditionId,
      TransferTo: transferTo,
      DoctorEmail: doctorEmail,
      PatientID: patientID,
    ).toJson();

    try {
      await medRepCollection.doc(id).set(newMedRep);

      if (newMedRep != null) {
        showToast(message: "Added Medical Diagnosis successfully");
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
  final String? date;
  final String? time;
  final String? diagnose;
  final String? MedConditionId;
  final String? TransferTo;
  final String? DoctorEmail;
  final String? PatientID;

  MedRepModel({
    this.date,
    this.time,
    this.diagnose,
    this.MedConditionId,
    this.TransferTo,
    this.DoctorEmail,
    this.PatientID,
  });

  static MedRepModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return MedRepModel(
      date: snapshot['date'],
      time: snapshot['time'],
      diagnose: snapshot['diagnose'],
      MedConditionId: snapshot['MedConditionId'],
      TransferTo: snapshot['TransferTo'],
      DoctorEmail: snapshot['DoctorEmail'],
      PatientID: snapshot['PatientID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "time": time,
      "diagnose": diagnose,
      "MedConditionId": MedConditionId,
      "TransferTo": TransferTo,
      "DoctorEmail": DoctorEmail,
      "PatientID": PatientID,
    };
  }
}
