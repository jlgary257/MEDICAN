import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MEDICAN', // App title displayed in the status bar
      home: MyHomePage(title: 'MedicAN'), // Set the home screen
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key); // Constructor

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.red,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto')), // Access title passed from MyApp
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align content vertically
          children: <Widget>[
            TextField(
              controller: username,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Username: ' +
                      username.text +
                      '\nPassword: ' +
                      password.text),
                  backgroundColor: Colors.green,
                ));
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
