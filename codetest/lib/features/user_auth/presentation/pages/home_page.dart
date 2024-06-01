  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:codetest/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
  import 'package:codetest/features/user_auth/presentation/pages/login_page.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';

  import '../../../../global/toast.dart';



  class HomePage extends StatelessWidget {
    const HomePage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text("Welcome to MEDICAN Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            SizedBox(height: 30),
            StreamBuilder<List<DoctorModel>>(
              stream:  _readData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                } if(snapshot.data!.isEmpty){
                  return Center(child: Text("No Data Yet"));
                }
                final doctors = snapshot.data;
                return Padding(padding: EdgeInsets.all(8),
                child: Column(
                  children: doctors!.map((Doctor) {
                    return ListTile(
                      leading: GestureDetector(
                        onTap: (){
                          _deleteData(Doctor.id!);
                        },
                        child: Icon(Icons.delete),
                      ),//delete
                      trailing: GestureDetector(
                        onTap: (){
                          _updateData(DoctorModel(
                            id: Doctor.id,
                            name: "John Wick",
                            email: "Malaysia",
                          ));
                        },
                        child: Icon(Icons.update),
                      ),//update
                      title: Text(Doctor.name!),
                      subtitle: Text(Doctor.email!),
                    );
                  } ).toList()
                ),);
              }
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context,"/login");
                showToast(message: "Sign out successfully");
              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }
    Stream<List<DoctorModel>> _readData(){
      final doctorCollection = FirebaseFirestore.instance.collection("Doctor");

      return doctorCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs.map((e) => DoctorModel.fromSnapshot(e),).toList());
  }



  void _updateData(DoctorModel doctorModel) {
    final doctorCollection = FirebaseFirestore.instance.collection("Doctor");

    final newDoctor = DoctorModel(
      name: doctorModel.name,
      email: doctorModel.email,
      id: doctorModel.id,
    ).toJson();

    doctorCollection.doc(doctorModel.id).update(newDoctor);

  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("Doctor");

    userCollection.doc(id).delete();

  }

  }

  class DoctorModel {
    final String? name;
    final String? email;

    final String? id;

    DoctorModel({this.name, this.email, this.id});


    static DoctorModel fromSnapshot(
        DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return DoctorModel(
        name: snapshot['name'],
        email: snapshot['email'],
        id: snapshot['DoctorId'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "name": name,
        "email": email,
        "DoctorId": id,
      };
    }

  }
