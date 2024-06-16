

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:codetest/global/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAdminData extends StatefulWidget {
  const AddAdminData({super.key});

  @override
  State<AddAdminData> createState() => _AddAdminDataState();
}

class _AddAdminDataState extends State<AddAdminData> {
  bool _isSigningUp = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Admin",),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Create new Admin",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            FormContainerWidget(
              controller: _nameController,
              hintText: "Name",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _createAdmin();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: _isSigningUp
                      ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    "Create Admin",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )*/
          ],
        ),
      ),
    );
  }
  void _createAdmin() async{
    setState(() {
      _isSigningUp = true;
    });

    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String staffId = "1";
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    final staffDocRef = FirebaseFirestore.instance.collection("Staff").doc(staffId);

    final adminDoc = staffDocRef.collection("Admin").doc();

    // Creating the new doctor model
    final newAdmin = AdminModel(
      name: name,
      email: email,
      AdminId: adminDoc.id,
      StaffId: staffId,
    ).toJson();

    // Adding the doctor information to the 'doctor' subcollection
    await adminDoc.set(newAdmin);

    setState(() {
      _isSigningUp = false;
    });

    if (user != null) {
      showToast(message: "Administrator is successfully created");
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => homeAdmin()),
              (route) => false);
    } else {
      showToast(message: "Error occurred");
    }
  }

}

class AdminModel {
  final String? name;
  final String? email;
  final String? AdminId;
  final String? StaffId;

  AdminModel({this.name, this.email, this.AdminId, this.StaffId});


  static AdminModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return AdminModel(
      name: snapshot['name'],
      email: snapshot['email'],
      AdminId: snapshot['AdminId'],
      StaffId: snapshot['StaffId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "AdminId": AdminId,
      "StaffId" : StaffId,
    };
  }

}
