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
          backgroundColor: Colors.red,
          title: Text("HomePage"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _createData(UserModel(
                  username: "Jane",
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
            StreamBuilder<List<UserModel>>(
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
                        child: Icon(Icons.delete),
                      ),
                      trailing: GestureDetector(
                        child: Icon(Icons.update),
                      ),
                      title: Text(Doctor.username!),
                      subtitle: Text(Doctor.address!),
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
    Stream<List<UserModel>> _readData(){
      final userCollection = FirebaseFirestore.instance.collection("Doctor");

      return userCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs.map((e) => UserModel.fromSnapshot(e),).toList());
  }

    void _createData(UserModel userModel) {
      final userCollection = FirebaseFirestore.instance.collection("Doctor");

      String id =userCollection.doc().id;

      final newUser = UserModel(
        username: userModel.username,
        address: userModel.address,
        age: userModel.age,
        id: id,
      ).toJson();

      userCollection.doc(id).set(newUser);
    }

  }

  class UserModel {
    final String? username;
    final String? address;
    final int? age;
    final String? id;

    UserModel({this.id, this.username, this.address, this.age});

    static UserModel fromSnapshot(
        DocumentSnapshot<Map<String, dynamic>> snapshot) {
      return UserModel(
        username: snapshot['username'],
        address: snapshot['address'],
        age: snapshot['age'],
        id: snapshot['id'],
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "username": username,
        "age": age,
        "id": id,
        "address": address,
      };
    }
  }
