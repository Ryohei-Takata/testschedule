import 'package:flutter/material.dart';
import 'package:flutter_app_cr/domain/book.dart';
import 'package:provider/provider.dart';

import 'add_book_model.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({this.book});
  final Book book;
  @override
  Widget build(BuildContext context) {
    final bool isUpate = book != null;
    final textEditingController = TextEditingController();

    if (isUpate) {
      textEditingController.text = book.title;
    }
    return ChangeNotifierProvider<AddBookModel>(
      create: (__) => AddBookModel(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(isUpate ? '本を編集' : '本を追加'),
            ),
            body: Consumer<AddBookModel>(
              builder: (context, model, child) {
                var imageFile = model.imageFile;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 160,
                        child: InkWell(
                          onTap: () async {
                            // カメラロールを開く
                            await model.showImagePicker();
                          },
                          child: model.imageFile != null
                              ? Image.file(model.imageFile)
                              : Container(
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      TextField(
                        controller: textEditingController,
                        onChanged: (text) {
                          model.bookTitle = text;
                        },
                      ),
                      RaisedButton(
                        child: Text(isUpate ? '更新する' : '追加する'),
                        onPressed: () async {
                          model.startLoading();
                          if (isUpate) {
                            await updateBook(model, context);
                          } else {
                            await addBook(model, context);
                          }
                          model.endLoading();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<AddBookModel>(builder: (context, model, child) {
            return model.isLoading
                ? Container(
                    color: Colors.grey.withOpacity(0.7),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox();
          })
        ],
      ),
    );
  }

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBookToFirebase();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('保存しました。'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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
  }

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(book);

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('更新しました。'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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
  }
}
