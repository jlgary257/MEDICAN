


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class updateMedReport extends StatefulWidget {
  const updateMedReport({super.key});

  @override
  State<updateMedReport> createState() => _updateMedReportState();
}

class _updateMedReportState extends State<updateMedReport> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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