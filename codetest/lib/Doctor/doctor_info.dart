import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:codetest/global/toast.dart';
import 'package:flutter/material.dart';

class UpdateDoctorInfo extends StatefulWidget {
  final String Id;
  const UpdateDoctorInfo({super.key, required this.Id});

  @override
  State<UpdateDoctorInfo> createState() => _UpdateDoctorInfoState();
}

class _UpdateDoctorInfoState extends State<UpdateDoctorInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String staffId = "2";

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data when the widget is initialized
  }

  Future<void> _loadData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Staff')
        .doc(staffId)
        .collection("Doctor")
        .doc(widget.Id)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
      });
    }
  }

  void _updateDoctorData() async {
    final doctorCollection = FirebaseFirestore.instance
        .collection('Staff')
        .doc(staffId)
        .collection("Doctor");

    final newDoctor = {
      'name': _nameController.text,
      'email': _emailController.text,
    };

    try {
      await doctorCollection.doc(widget.Id).update(newDoctor);
      showToast(message: "Doctor information updated successfully");
    } catch (e) {
      showToast(message: "Failed to update doctor information: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Medican"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Update Doctor Information",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _nameController,
              hintText: "Name",
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _updateDoctorData,
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
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
      "StaffId": StaffId,
    };
  }
}
