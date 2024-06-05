




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/user_auth/presentation/pages/login_page.dart';
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
      appBar: AppBar(
        title: Text("HOME Doctor", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        actions: <Widget>[GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
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
        children: [ Center(
          child: Text("Welcome Dr."),
        )
          
        ],
      ),
    );
  }
}
