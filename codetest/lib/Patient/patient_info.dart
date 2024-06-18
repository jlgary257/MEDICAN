



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:codetest/global/toast.dart';
import 'package:flutter/material.dart';

class createPatient extends StatefulWidget {
  const createPatient({super.key});

  @override
  State<createPatient> createState() => _createPatientState();
}

class _createPatientState extends State<createPatient> {
  TextEditingController _ICController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();

  void dispose(){
    _ICController.dispose();
    _nameController.dispose();
    _genderController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Admin",),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Patient Registration",
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
            FormContainerWidget(
              controller: _genderController,
              hintText: "Gender",
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _phoneNoController,
              hintText: "Phone No.",
            ),
            SizedBox(height: 30),
            RedElevatedButton(onPressed: addPatient, text: "Register"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void addPatient() async{
      String IC = _ICController.text;
      String name = _nameController.text;
      String gender = _genderController.text;
      String phoneNo = _phoneNoController.text;
      
      final patientCollection = FirebaseFirestore.instance.collection("Patient");
      String id = patientCollection.doc().id;
      
      final newPatient = PatientModel(
        ID: id,
        IC: IC,
        name: name,
        gender: gender,
        phoneNo: phoneNo
      ).toJson();

      try {
        await patientCollection.doc(id).set(newPatient);

        if (newPatient != null){
          showToast(message: "Registered new patient successfully");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => homeAdmin()),(route) => false);
        }

      } on Exception catch (e) {
        print("Error :  ${e}");
      }
  }
}

class PatientModel{
  final String? ID;
  final String? IC;
  final String? name;
  final String? gender;
  final String? phoneNo;

  PatientModel({
    this.ID,
    this.IC,
    this.name,
    this.gender,
    this.phoneNo
  });

  static PatientModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return PatientModel(
      ID: snapshot['ID'],
      IC: snapshot['IC'],
      name: snapshot['name'],
      gender: snapshot['gender'],
      phoneNo: snapshot['phoneNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID": ID,
      "IC": IC,
      "name": name,
      "gender": gender,
      "phoneNo": phoneNo,
    };
  }
}
