import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signup() async {
    if (mail.isEmpty) {
      throw ('input mail!!');
    }
    if (password.isEmpty) {
      throw ('input password!!');
    }
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: mail, password: password))
        .user;

    final email = user.email;
    Firestore.instance.collection('users').add({
      'email': email,
      'createdAt': Timestamp.now(),
    });
  }
}
