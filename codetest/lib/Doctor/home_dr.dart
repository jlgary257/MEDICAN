import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Doctor/doctor_info.dart';
import 'package:codetest/Doctor/form_consult.dart';
import 'package:codetest/Doctor/patient_info.dart';
import 'package:codetest/features/user_auth/firebase_auth_implementation/password_change.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';

class homeDoctor extends StatefulWidget {
  const homeDoctor({super.key});

  @override
  State<homeDoctor> createState() => _homeDoctorState();
}

class _homeDoctorState extends State<homeDoctor> {
  String? _doctorId;

  @override
  void initState() {
    super.initState();
    _fetchDoctorId();
  }

  Future<void> _fetchDoctorId() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? '';

    if (email.isNotEmpty) {
      String? doctorId = await getDoctorIdByEmail(email);
      setState(() {
        _doctorId = doctorId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Dr.", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 50),
              RedElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrForm()),
                  );
                },
                text: "Diagnose Patient",
              ),
              SizedBox(height: 10),
              RedElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => viewPatientInfo()),
                  );
                },
                text: "View Patient Information",
              ),
              SizedBox(height: 10),
              RedElevatedButton(
                onPressed: () {
                  if (_doctorId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateDoctorInfo(Id: _doctorId!)),
                    );
                  } else {
                    showToast(message: "Doctor ID not found");
                  }
                },
                text: "Update Information",
              ),
              SizedBox(height: 10),
              RedElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
                text: "Change Password",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getDoctorIdByEmail(String email) async {
    print(email);
    try {
      final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");
      final doctorQuerySnapshot = await doctorCollection.where('email', isEqualTo: email).get();

      if (doctorQuerySnapshot.docs.isNotEmpty) {
        return doctorQuerySnapshot.docs[0].id; // Return the document ID as the Doctor ID
      }

      return null; // Doctor ID not found
    } catch (error) {
      print('Error getting doctor ID: $error');
      return null; // Handle potential errors
    }
  }
}
