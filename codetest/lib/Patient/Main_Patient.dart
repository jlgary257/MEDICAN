

import 'package:codetest/Patient/patient_info.dart';
import 'package:codetest/features/user_auth/presentation/widgets/basic_fx.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class MainPatient extends StatefulWidget {
  const MainPatient({super.key});

  @override
  State<MainPatient> createState() => _MainPatientState();
}

class _MainPatientState extends State<MainPatient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Medican",),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Patient Management",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            SizedBox(height: 30,),
            RedElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => createPatient()),
              );
            },
              text: "New Patient",
            ),
            SizedBox(height: 20,),
            RedElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => updatePatient()),
              );
            },
              text: "Update Patient",
            ),
            SizedBox(height: 20,),
            RedElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TabulateData()),
              );
            },
              text: "View Patient",
            ),
          ],

        ),
      ),
    );
  }
}
