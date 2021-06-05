// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_cr/bookl_list/add_book/add_book_page.dart';
import 'package:flutter_app_cr/bookl_list/book_list_model.dart';
import 'package:flutter_app_cr/domain/book.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (__) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('本の一覧'),
        ),
        body: Consumer<BookListModel>(
          builder: (context, model, child) {
            final books = model.books;
            var map = books.map(
              (book) => ListTile(
                leading: Image.network(book.imageUrl),
                title: Text(book.title),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBookPage(
                          book: book,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                    model.fetchBooks();
                  },
                ),
                onLongPress: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('${book.title}を削除しますか？'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () async {
                              Navigator.of(context).pop();

                              // TODO 削除のAPIをたたく
                              await deleteBook(context, model, book);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
            final listTiles = map.toList();
            return ListView(
              children: listTiles,
            );
          },
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              model.fetchBooks();
            },
          );
        }),
      ),
    );
  }
}

Future deleteBook(BuildContext context, BookListModel model, Book book) async {
  try {
    await model.deleteBook(book);

    model.fetchBooks();
  } catch (e) {
    print(e.toString());
    await _showDialog(context, e.toString());
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
