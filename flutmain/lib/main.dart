import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MEDICAN', // App title displayed in the status bar
      home: MyHomePage(title: 'MEDICAN'), // Set the home screen
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
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Access title passed from MyApp
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align content vertically
          children: <Widget>[
            TextField(
              controller: username,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: password,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Text('Jojo'),
            ElevatedButton(
              onPressed: () {
                final snackBar = SnackBar(
                  content: Text('$username'), // Text displayed in the Snackbar
                  backgroundColor:
                      Colors.red, // Optional: Customize background color
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
