import 'package:flutter/material.dart';
import 'package:flutter_app_cr/presentation/signup/signup_model.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignupModel>(
      create: (__) => SignupModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('サインアップ'),
        ),
        body: Consumer<SignupModel>(
          builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'example@tboy.com'),
                    controller: mailController,
                    onChanged: (text) {
                      model.mail = text;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'パスワード'),
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (text) {
                      model.password = text;
                    },
                  ),
                  RaisedButton(
                    child: Text('登録する'),
                    onPressed: () async {
                      try {
                        await model.signup();
                        _showDialog(context, 'input complete');
                      } catch (e) {
                        _showDialog(context, e.toString());
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future _showDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
