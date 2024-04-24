import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
            Text('Jojo'),
            ElevatedButton(
              onPressed: () {
                final snackBar = SnackBar(
                  content: Text('Username: {$username}\n'
                      'Password: $password'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
