




import 'package:codetest/Doctor/form_consult.dart';
import 'package:codetest/Doctor/patient_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/pages/login_page.dart';
import '../features/user_auth/presentation/pages/signUpPage.dart';
import '../features/user_auth/presentation/widgets/form_container_widget.dart';
import '../global/toast.dart';

class homeDoctor extends StatefulWidget {
  const homeDoctor({super.key});

  @override
  State<homeDoctor> createState() => _homeDoctorState();
}

class _homeDoctorState extends State<homeDoctor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor",),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome Dr.",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              SizedBox(height: 50,),
              RedElevatedButton(onPressed:(){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrForm()));
                  }   , text: "Diagnose Patient"),
              SizedBox(height: 10,),
              RedElevatedButton(onPressed:(){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => viewPatientInfo()));
                  }   , text: "View Patient Information"),
              SizedBox(height: 10,),
              RedElevatedButton(onPressed:(){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePatientInfo(documentId: "06kifAuy9WP7ZZchOG0y")));
                  }   , text: "Update Information")
            ],
          ),
        ),
      ),
    );
  }
}
