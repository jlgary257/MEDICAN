import 'package:codetest/Admin/home_admin.dart';
import 'package:codetest/Doctor/home_dr.dart';
import 'package:codetest/data_visual/bar_chart_example.dart';
import 'package:codetest/data_visual/yearCases.dart';
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
    FirebaseOptions(apiKey: "AIzaSyCdsY6gatBHi8j89xR1pBGszy_B_48V2Cg",
        appId: "1:220570038936:web:88fbe427e147e5103c56ed",
        messagingSenderId: "220570038936",
        projectId: "medican-jl"));
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
        '/homeDr': (context) => homeDoctor(),
      },
    );
  }
}


