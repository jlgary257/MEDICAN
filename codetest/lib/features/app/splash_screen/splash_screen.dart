import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:codetest/Doctor/patient_info.dart';
import 'package:codetest/data_visual/SumCasesEx.dart';
import 'package:codetest/data_visual/bar_chart_example.dart';
import 'package:codetest/data_visual/yearCases.dart';
import 'package:codetest/features/user_auth/firebase_auth_implementation/password_change.dart';
import 'package:codetest/features/user_auth/presentation/pages/login_page.dart';
import 'package:codetest/features/user_auth/presentation/widgets/basic_fx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({Key? key, this.child}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TraumaCase(),),
              (route) => false // Predicate to remove all routes
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text("Welcome to Medical Analysis System",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              )).animate().fade(duration: 1000.ms),
        ));
  }
}
