




import 'package:codetest/Doctor/form_consult.dart';
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
              SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.red,padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),),
                    onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DrForm()));
                    },
                  child:  Center(
                      child : Text(
                        "Diagnose Patient",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
