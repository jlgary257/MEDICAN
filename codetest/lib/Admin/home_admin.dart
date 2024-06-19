

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/admin_info.dart';
import 'package:codetest/Patient/Main_Patient.dart';
import 'package:codetest/Patient/patient_info.dart';
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
      appBar: MainAppBar(title: "Home Admin",),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("View Doctor information",style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          SizedBox(height:30),
          StreamBuilder<List<DoctorModel>>(
              stream:  _readData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                } if(snapshot.data!.isEmpty){
                  return Center(child: Text("No Data Yet"));
                }
                final doctors = snapshot.data;
                return Padding(padding: EdgeInsets.all(8),
                  child: Column(
                      children: doctors!.map((Doctor) {
                        return ListTile(
                          leading: GestureDetector(
                            onTap: (){
                              showDeleteConfirmation(context, () {
                                _deleteData(Doctor.DoctorId!);
                              });;
                            },
                            child: Icon(Icons.delete),
                          ),//delete//update
                          title: Text(Doctor.name!),
                          subtitle: Text(Doctor.email!),
                        );
                      } ).toList()
                  ),);
              }
          ),
          RedElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            text: "New Doctor",
          ),
              SizedBox(height: 10,),
          RedElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAdminData()),
              );
            },
            text: "New Admin",
          ),
            SizedBox(height: 10,),
            RedElevatedButton(
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPatient()),
              );
              },
              text: "Patient",
              ),
]
      ),
    );
  }
  Stream<List<DoctorModel>> _readData(){
    final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");

    return doctorCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e),).toList());
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

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");

    userCollection.doc(id).delete();

  }
}


class DoctorModel {
  final String? name;
  final String? email;
  final String? DoctorId;
  final String? StaffId;

  DoctorModel({this.name, this.email, this.DoctorId, this.StaffId});


  static DoctorModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
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
      "StaffId" : StaffId,
    };
  }
}