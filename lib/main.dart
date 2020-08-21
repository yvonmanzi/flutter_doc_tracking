import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/bloc/bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_bloc.dart';
import 'package:doctracking/src/repository/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repository.dart';
import 'package:doctracking/src/ui/doc_list.dart';
import 'package:doctracking/src/ui/new_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    routes: {
      '/new_doc': (BuildContext context) => MultiBlocProvider(providers: [
            BlocProvider<DocFirestoreBloc>(
                create: (context) => DocFirestoreBloc(
                    repository: DocRepository(
                        docFirestoreClient: DocFirestoreClient(
                            firestoreInstance: Firestore.instance)))),
            BlocProvider<DocFormBloc>(
              create: (context) => DocFormBloc(
                  initialState: DocumentFormInitial(),
                  docFirestoreBloc: DocFirestoreBloc(
                    repository: DocRepository(
                        docFirestoreClient: DocFirestoreClient(
                            firestoreInstance: Firestore.instance)),
                  )),
            ),
          ], child: NewDoc()),
    },
    title: 'doc tracking',
    theme: ThemeData(
      primaryColorBrightness: Brightness.dark,
      primarySwatch: Colors.deepOrange,
      secondaryHeaderColor: Colors.deepOrange,
    ),
    home: App(),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('DocExpire'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: null,
          )
        ],
      ),
      body: BlocProvider<DocFirestoreBloc>(
        create: (context) => DocFirestoreBloc(
            repository: DocRepository(
                docFirestoreClient:
                    DocFirestoreClient(firestoreInstance: Firestore.instance))),
        child: DocList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'add new doc',
        onPressed: () => Navigator.pushNamed(context, '/new_doc'),
      ),
    );
  }
}
