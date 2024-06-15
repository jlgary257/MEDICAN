


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/form_consult.dart';
import 'package:codetest/features/user_auth/presentation/widgets/basic_fx.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class viewPatientInfo extends StatefulWidget {
  const viewPatientInfo({super.key});

  @override
  State<viewPatientInfo> createState() => _viewPatientInfoState();
}

class _viewPatientInfoState extends State<viewPatientInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor",),
      body:  TabulateData()
    );
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
