


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SumTrauma extends StatefulWidget {
  const SumTrauma({super.key});


  @override
  State<SumTrauma> createState() => _SumTraumaState();
}

class _SumTraumaState extends State<SumTrauma> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getSumCases() async {
    QuerySnapshot querySnapshot = await _firestore.collection('MedicalCondition').doc('5').collection('Trauma').get();
    return querySnapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<int>(
        future: _getSumCases(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          } else if (snapshot.hasError){
            return Text('Error:${snapshot.error}');
          } else if (snapshot.hasData){
            return Text('Total number of cases: ${snapshot.data}');
          }
          else{
            return Text('No data found');
          }
        },
      ),
    );
  }
}
