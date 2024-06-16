


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateDoctorInfo extends StatefulWidget {
  const UpdateDoctorInfo({super.key});

  @override
  State<UpdateDoctorInfo> createState() => _UpdateDoctorInfoState();
}

class _UpdateDoctorInfoState extends State<UpdateDoctorInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
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
