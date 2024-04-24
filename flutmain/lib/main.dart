import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App', // App title displayed in the status bar
      home: MyHomePage(title: 'Hello World!'), // Set the home screen
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
  int _counter = 0; // State variable to keep track of counter

  void _incrementCounter() {
    setState(() {
      // Update state and rebuild the widget
      _counter++;
    });
  }

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
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter', // Display counter value
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
