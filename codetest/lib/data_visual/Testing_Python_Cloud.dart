import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = 'Loading...';

  Future<void> fetchMessage() async {
    const url = 'https://us-central1-medican-jl.cloudfunctions.net/testing_python_flutter'; // Replace with your actual URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          message = response.body;
        });
      } else {
        setState(() {
          message = 'Error fetching message: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Failed to load message: $e';
      });
    }
  }



  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, World!'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}