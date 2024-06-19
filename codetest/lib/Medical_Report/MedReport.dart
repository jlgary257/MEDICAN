


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class createMedRep extends StatefulWidget {
  const createMedRep({super.key});

  @override
  State<createMedRep> createState() => _createMedRepState();
}

class _createMedRepState extends State<createMedRep> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _Controller = TextEditingController();
  final TextEditingController _patController = TextEditingController();
  final TextEditingController _patController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Admin"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Medical Report",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            FormContainerWidget(
              controller: _ICController,
              hintText: "IC",
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _nameController,
              hintText: "Name",
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _phoneNoController,
              hintText: "Phone No.",
            ),
            SizedBox(height: 30),
            RedElevatedButton(onPressed: addMedicalReport, text: "Register"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
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
      "MedConditionId": MedConditionId,
      "diagnose": diagnose,
      "TransferTo": TransferTo,
      "DoctorID": DoctorID,
      "PatientID": PatientID,
    };
  }
}