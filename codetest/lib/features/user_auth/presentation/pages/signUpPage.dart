import 'package:codetest/features/user_auth/presentation/pages/login_page.dart';
import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            FormContainerWidget(
              hintText: "Username",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              hintText: "Email",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              hintText: "Name",
              isPasswordField: false,
            ),
            SizedBox(height: 10),
            FormContainerWidget(
              hintText: "Password",
              isPasswordField: true,
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                "Sign Up",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context) => LoginPage()),(route) => false);
                  },
                  child: Text("Login", style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                )
              ],)
          ],
        ),
      ),
    );
  }
}
