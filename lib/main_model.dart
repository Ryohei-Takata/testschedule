import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  String tboyText = 'Tboyさんじゃないよ';

  void changeTboyText() {
    tboyText = 'tboyさんかっこいい!';
    notifyListeners();
  }
}
