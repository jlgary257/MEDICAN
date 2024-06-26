


import '../../../global/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../global/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == 'email-already-in-use'){
        showToast(message: 'The email is already in use.');
      } else{
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signinEmNPass(String email, String password) async {
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        showToast(message: 'Invalid login credentials.');
      } else{
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}