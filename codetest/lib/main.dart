import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'features/app/splash_screen/splash_screen.dart';
import 'features/user_auth/presentation/pages/home_page.dart';
import 'features/user_auth/presentation/pages/signUpPage.dart';

//void main() => runApp(MyApp());

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options:
    FirebaseOptions(apiKey: "AIzaSyDpdg5OJ7RPjBJ1H6P58RHBmbwXpJ0Ht0k",
        appId: "1:1075732898430:web:2820d3c5f6efb631f4ee2f",
        messagingSenderId: "1075732898430",
        projectId: "medican-257"));
  }else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MEDICAN', // App title displayed in the status bar
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage()
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/homeAd': (context) => homeAdmin(),
        //added in main for testing-branches
      },
    );
  }
}


