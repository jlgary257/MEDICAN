


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/pages/signUpPage.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/widgets/basic_fx.dart';
import '../global/toast.dart';
import 'home_admin.dart';

class AdminDoctorMain extends StatefulWidget {
  const AdminDoctorMain({super.key});

  @override
  State<AdminDoctorMain> createState() => _AdminDoctorMainState();
}

class _AdminDoctorMainState extends State<AdminDoctorMain> {
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
                "Doctor Management",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<DoctorModel>>(
                stream: _readData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("No Data Yet"));
                  }
                  final doctors = snapshot.data;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: doctors!.map((doctor) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                showDeleteConfirmation(context, () {
                                  deleteData(doctor.DoctorId!);
                                });
                              },
                              child: Icon(Icons.delete),
                            ), //delete//update
                            title: Text(doctor.name!),
                            subtitle: Text(doctor.email!),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            RedElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              text: "New Doctor",
            ),
            SizedBox(height: 10),
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