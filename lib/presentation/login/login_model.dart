import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future login() async {
    if (mail.isEmpty) {
      throw ('input mail!!');
    }
    if (password.isEmpty) {
      throw ('input password!!');
    }
    final result =
        await _auth.signInWithEmailAndPassword(email: mail, password: password);
    final uid = result.user.uid;
  }
}
