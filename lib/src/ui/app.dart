import 'package:doctracking/src/bloc/doc_firestore/doc_firestore_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/doc_firestore/doc_firestore.dart';
import 'doc_list.dart';

const menuReset = "Delete all documents";
// Storing options in a list so we can add more options later
List<String> menuOptions = const <String>[menuReset];

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  DocFirestoreBloc _docFirestoreBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('DocExpire'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _selectMenu,
            itemBuilder: (BuildContext context) {
              return menuOptions.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: DocList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'add new doc',
        onPressed: () => Navigator.pushNamed(context, '/new_doc'),
      ),
    );
  }

  void _selectMenu(String value) async {
    switch (value) {
      case menuReset:
        _showResetDialog();
    }
  }

  void _showResetDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Dco you want to delete all docs'),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () async {
                  _docFirestoreBloc =
                      BlocProvider.of<DocFirestoreBloc>(context);
                  _docFirestoreBloc.add(DocFirestoreDeleteAll());
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
