

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("HOME Administrator",style: TextStyle(color: Colors.white),),
        actions: <Widget>[GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context,"/login");
            showToast(message: "Sign out successfully");
          },
          child: Container(
            height: 45,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Sign Out",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )],
      ),
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
                              _deleteData(Doctor.DoctorId!);
                            },
                            child: Icon(Icons.delete),
                          ),//delete
                          trailing: GestureDetector(
                            onTap: (){
                              _updateData(DoctorModel(
                                DoctorId: Doctor.DoctorId,
                                name: "John Wick",
                                email: "Malaysia",
                              ));
                            },
                            child: Icon(Icons.update),
                          ),//update
                          title: Text(Doctor.name!),
                          subtitle: Text(Doctor.email!),
                        );
                      } ).toList()
                  ),);
              }
          ),
        ],
      ),
    );
  }
  Stream<List<DoctorModel>> _readData(){
    final doctorCollection = FirebaseFirestore.instance.collection("Doctor");

    return doctorCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e),).toList());
  }



  void _updateData(DoctorModel doctorModel) {
    final doctorCollection = FirebaseFirestore.instance.collection("Doctor");

    final newDoctor = DoctorModel(
      name: doctorModel.name,
      email: doctorModel.email,
      DoctorId: doctorModel.DoctorId,
      StaffId: "DR",
    ).toJson();

    doctorCollection.doc(doctorModel.DoctorId).update(newDoctor);

  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("Doctor");

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