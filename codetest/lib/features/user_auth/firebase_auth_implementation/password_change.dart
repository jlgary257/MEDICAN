import 'package:codetest/features/user_auth/presentation/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showToast(message: "Please fill in all fields");
      return;
    }

    if (newPassword != confirmPassword) {
      showToast(message: "New password and confirm password do not match");
      return;
    }

    User? user = _auth.currentUser;

    if (user == null) {
      showToast(message: "No user is currently logged in");
      return;
    }

    // Re-authenticate the user
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      showToast(message: "Password successfully changed");
    } catch (e) {
      showToast(message: "Failed to change password: $e");
    }
  }

  void showToast({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Home Doctor"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Change Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                FormContainerWidget(
                  controller: _currentPasswordController,
                  hintText: "Current Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 20),
                FormContainerWidget(
                  controller: _newPasswordController,
                  hintText: "New Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 20),
                FormContainerWidget(
                  controller: _confirmPasswordController,
                  hintText: "Confirm New Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 20),
                RedElevatedButton(
                  onPressed: _changePassword,
                  text: "Change Password",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
