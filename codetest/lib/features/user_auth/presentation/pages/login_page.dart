import 'package:codetest/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:codetest/features/user_auth/presentation/pages/home_page.dart';
import 'package:codetest/features/user_auth/presentation/pages/signUpPage.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:codetest/global/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Text("Login"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 300),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
            GestureDetector(
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
            ),
            SizedBox(height: 20),
            Row(
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
            )
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

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      showToast(message: "User is successfully Sign in");
      Navigator.pushNamed(context, "/home");
    } else {
      showToast(message: "Error occurred");
    }
  } //end _SignIn

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: '1075732898430-hkg1grj1r0thfaqllsmli1v38m17uknd.apps.googleusercontent.com',
    );
//clientId: '1075732898430-hkg1grj1r0thfaqllsmli1v38m17uknd.apps.googleusercontent.com',
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
}