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
          title: Text("HomePage"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _createData(UserModel(
                  name: "Jane",
                    address: "India",
                    age: 60
                ));

              },
              child: Container(
                height: 45,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Create Data",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Center(
                child: Text("Welcome to MEDICAN Home",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))),
            SizedBox(height: 30),
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
    void _createData(UserModel userModel) {
      final userCollection = FirebaseFirestore.instance.collection("Doctor");

      String id =userCollection.doc().id;

      final newUser = UserModel(
        name: userModel.name,
        address: userModel.address,
        age: userModel.age,
        id: id,
      ).toJson();

      userCollection.doc(id).set(newUser);
    }

  }

  class UserModel {
    final String? name;
    final String? address;
    final int? age;
    final String? id;

    UserModel({this.id, this.name, this.address, this.age});

    static UserModel fromSnapshot(
        DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return UserModel(
        name: snapshot['username'],
        address: snapshot['address'],
        age: snapshot['age'],
        id: snapshot['id'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "username": name,
        "age": age,
        "id": id,
        "adress": address,
      };
    }
  }
