import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/Admin_doctor.dart';
import 'package:codetest/Admin/admin_info.dart';
import 'package:codetest/Patient/Main_Patient.dart';
import 'package:codetest/Patient/patient_info.dart';
import 'package:codetest/data_visual/MainBI.dart';
import 'package:codetest/features/user_auth/presentation/widgets/basic_fx.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/pages/login_page.dart';
import '../features/user_auth/presentation/pages/signUpPage.dart';
import '../global/toast.dart';

class homeAdmin extends StatefulWidget {
  const homeAdmin({super.key});

  @override
  State<homeAdmin> createState() => _homeAdminState();
}

class _homeAdminState extends State<homeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "MEDICAN"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Administrator",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            RedElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDoctorMain()),
                );
              },
              text: "Doctor",
            ),
            SizedBox(height: 10),
            RedElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAdminData()),
                );
              },
              text: "New Admin",
            ),
            SizedBox(height: 10),
            RedElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPatient()),
                );
              },
              text: "Patient",
            ),
            SizedBox(height: 10),
            RedElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainBi()),
                );
              },
              text: "Analytics & BI",
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<DoctorModel>> _readData() {
    final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");

    return doctorCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e)).toList());
  }

  void _updateData(DoctorModel doctorModel) {
    final doctorCollection = FirebaseFirestore.instance.collection("Doctor");

    final newDoctor = DoctorModel(
      name: doctorModel.name,
      email: doctorModel.email,
      DoctorId: doctorModel.DoctorId,
      StaffId: "2",
    ).toJson();

    doctorCollection.doc(doctorModel.DoctorId).update(newDoctor);
  }

  void deleteData(String id) async{
    try {
      await FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor").doc(id).delete();
      showToast(message: "Doctor deleted successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => homeAdmin()),
            (route) => false,
      );
    } on Exception catch (e) {
      print("Error: ${e}");
    }
  }
}

class DoctorModel {
  final String? name;
  final String? email;
  final String? DoctorId;
  final String? StaffId;

  DoctorModel({this.name, this.email, this.DoctorId, this.StaffId});

  static DoctorModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return DoctorModel(
      name: snapshot['name'],
      email: snapshot['email'],
      DoctorId: snapshot['DoctorId'],
      StaffId: snapshot['StaffId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "DoctorId": DoctorId,
      "StaffId": StaffId,
    };
  }
}
