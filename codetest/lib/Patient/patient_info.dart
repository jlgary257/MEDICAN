import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/home_admin.dart';
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
  String _selectedGender = "Male";
  TextEditingController _phoneNoController = TextEditingController();

  @override
  void dispose() {
    _ICController.dispose();
    _nameController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

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
            RedElevatedButton(onPressed: addPatient, text: "Register"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void addPatient() async {
    String IC = _ICController.text;
    String name = _nameController.text;
    String gender = _selectedGender;
    String phoneNo = _phoneNoController.text;

    if (IC.length != 12 || !RegExp(r'^[0-9]+$').hasMatch(IC)) {
      showToast(message: "IC number must be 12 digits and numeric");
      return;
    }

    if (phoneNo.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNo)) {
      showToast(message: "Phone number must be 10 digits and numeric");
      return;
    }

    final patientCollection = FirebaseFirestore.instance.collection("Patients");
    String id = patientCollection.doc().id;

    final newPatient = PatientModel(
      ID: id,
      IC: IC,
      name: name,
      gender: gender,
      phoneNo: phoneNo,
    ).toJson();

    try {
      await patientCollection.doc(id).set(newPatient);
      showToast(message: "Registered new patient successfully");
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

class updatePatient extends StatefulWidget {
  const updatePatient({super.key});

  @override
  State<updatePatient> createState() => _updatePatientState();
}

class _updatePatientState extends State<updatePatient> {
  TextEditingController _ICController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  String _selectedGender = "Male";
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  bool _isPatientFound = false;
  String _patientID = '';

  @override
  void dispose() {
    _ICController.dispose();
    _nameController.dispose();
    _phoneNoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Update Patient"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update Patient",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(hintText: "Search by IC or Phone No."),
            ),
            SizedBox(height: 10),
            RedElevatedButton(onPressed: searchPatient, text: "Search"),
            SizedBox(height: 30),
            if (_isPatientFound) ...[
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
              RedElevatedButton(onPressed: updatePatient, text: "Update"),
              SizedBox(height: 20),
              RedElevatedButton(onPressed: () =>deletePatient(_patientID), text: "Delete")
            ]
          ],
        ),
      ),
    );
  }

  void searchPatient() async {
    String searchValue = _searchController.text;
    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (RegExp(r'^[0-9]+$').hasMatch(searchValue)) {
      if (searchValue.length == 12) {
        // Search by IC
        snapshot = await FirebaseFirestore.instance
            .collection("Patients")
            .where('IC', isEqualTo: searchValue)
            .get();
      } else if (searchValue.length == 10) {
        // Search by Phone No
        snapshot = await FirebaseFirestore.instance
            .collection("Patients")
            .where('phoneNo', isEqualTo: searchValue)
            .get();
      } else {
        showToast(message: "Invalid IC or Phone number format");
        return;
      }

      if (snapshot.docs.isNotEmpty) {
        final patientData = snapshot.docs.first.data();
        setState(() {
          _ICController.text = patientData['IC'];
          _nameController.text = patientData['name'];
          _selectedGender = patientData['gender'];
          _phoneNoController.text = patientData['phoneNo'];
          _isPatientFound = true;
          _patientID = snapshot.docs.first.id;
        });
      } else {
        showToast(message: "Patient not found");
      }
    } else {
      showToast(message: "IC or Phone number must be numeric");
    }
  }

  void updatePatient() async {
    String IC = _ICController.text;
    String name = _nameController.text;
    String gender = _selectedGender;
    String phoneNo = _phoneNoController.text;

    if (IC.length != 12 || !RegExp(r'^[0-9]+$').hasMatch(IC)) {
      showToast(message: "IC number must be 12 digits and numeric");
      return;
    }

    if (phoneNo.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phoneNo)) {
      showToast(message: "Phone number must be 10 digits and numeric");
      return;
    }

    final patientCollection = FirebaseFirestore.instance.collection("Patients");

    final updatedPatient = PatientModel(
      ID: _patientID,
      IC: IC,
      name: name,
      gender: gender,
      phoneNo: phoneNo,
    ).toJson();

    try {
      await patientCollection.doc(_patientID).update(updatedPatient);
      showToast(message: "Patient updated successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => homeAdmin()),
            (route) => false,
      );
    } on Exception catch (e) {
      print("Error: ${e}");
    }
  }

  void deletePatient(String id) async {
    try {
      await FirebaseFirestore.instance.collection("Patients").doc(id).delete();
      showToast(message: "Patient deleted successfully");
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



class PatientModel {
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
    this.phoneNo,
  });

  static PatientModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
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


