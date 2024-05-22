import 'package:codetest/features/user_auth/presentation/pages/home_page.dart';
import 'package:codetest/features/user_auth/presentation/pages/signUpPage.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Login", style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),)),
              ),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?"),
              SizedBox(width: 5),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),(route) => false);
                },
                child: Text("Sign Up", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              )
            ],)
          ],
        ),
      ),
    );
  }
}
