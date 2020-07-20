import 'package:doctracking/src/ui/new_doc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/new_doc': (BuildContext context) => NewDoc()},
      title: 'doc tracking',
      theme: ThemeData(
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('DocExpire'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: null,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
          onPressed: () => Navigator.pushNamed(context, '/new_doc'),
        ),
      ),
    );
  }
}
