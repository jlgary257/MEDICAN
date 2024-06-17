import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:codetest/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:codetest/features/user_auth/presentation/pages/home_page.dart';
import 'package:codetest/features/user_auth/presentation/pages/signUpPage.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:codetest/global/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigningIn = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("MEDICAN",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 40)).animate().fadeIn()
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
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
                _signIn();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: _isSigningIn
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            SizedBox(height: 10,),
            /*GestureDetector(
              onTap: () {
                _signInWithGoogle();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.35),
                  borderRadius: BorderRadius.circular(10),),
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.google, color: Colors.red,),
                        SizedBox(width: 5,),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),*/
            SizedBox(height: 20),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                            (route) => false);
                  },
                  child: Text(
                    "Sign Up",
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

  void _signIn() async {
    setState(() {
      _isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;


    User? user = await _auth.signinEmNPass(email, password);

    String? staffId = await getStaffIdByEmail(email) ;

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      showToast(message: "User is successfully Sign in");
      if (staffId == "1") {
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => homeAdmin()),
                (route) => false);
      } else if (staffId == "2"){
        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => homeDoctor()),
                (route) => false);
      }else{
        print("Error: " );
      }
    } else {
      showToast(message: "Error occurred");
    }
  } //end _SignIn

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: '1075732898430-hkg1grj1r0thfaqllsmli1v38m17uknd.apps.googleusercontent.com',
    );

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await
        googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushNamed(context, "/home");
      }
    } catch (e) {
      showToast(message: "Error occurred: ${e}");
    }
  }

  Stream<List<DoctorModel>> _readData(){
    final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");

    return doctorCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e),).toList());
  }

  Future<String?> getStaffIdByEmail(String email) async {
    try {
      // Check in the Doctor collection
      final doctorCollection = FirebaseFirestore.instance.collection("Staff").doc("2").collection("Doctor");
      final doctorQuerySnapshot = await doctorCollection.where('email', isEqualTo: email).get();

      if (doctorQuerySnapshot.docs.isNotEmpty) {
        return doctorQuerySnapshot.docs[0]['StaffId'] as String;
      }

      // Check in the Admin collection
      final adminCollection = FirebaseFirestore.instance.collection("Staff").doc("1").collection("Admin");
      final adminQuerySnapshot = await adminCollection.where('email', isEqualTo: email).get();

      if (adminQuerySnapshot.docs.isNotEmpty) {
        return adminQuerySnapshot.docs[0]['StaffId'] as String;
      }

      return null; // Staff ID not found
    } catch (error) {
      print('Error getting staff ID: $error');
      return null; // Handle potential errors
    }
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
      "StaffId" : StaffId,
    };
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
