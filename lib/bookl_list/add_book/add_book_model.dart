import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_cr/domain/book.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';
  File imageFile;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future addBookToFirebase() async {
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください。');
    }

    final imageUrl = await _uploadImage();
    Firestore.instance.collection('books').add({
      'title': bookTitle,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  Future updateBook(Book book) async {
    final document =
        Firestore.instance.collection('books').document(book.documentID);
    await document.updateData({
      'title': bookTitle,
      'updateAt': Timestamp.now(),
    });
  }

  Future<String> _uploadImage() async {
    final storage = FirebaseStorage.instance;
    StorageTaskSnapshot snapshot = await storage
        .ref()
        .child("books/$bookTitle")
        .putFile(imageFile)
        .onComplete;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
