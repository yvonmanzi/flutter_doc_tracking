import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/bloc/bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_bloc.dart';
import 'package:doctracking/src/repository/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repository.dart';
import 'package:doctracking/src/ui/app.dart';
import 'package:doctracking/src/ui/new_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final firestoreInstance = Firestore.instance;
  final docFirestoreClient =
      DocFirestoreClient(firestoreInstance: firestoreInstance);
  final repository = DocRepository(docFirestoreClient: docFirestoreClient);
  runApp(MaterialApp(
    routes: {
      '/new_doc': (BuildContext context) => MultiBlocProvider(providers: [
            BlocProvider<DocFirestoreBloc>(
                create: (context) => DocFirestoreBloc(repository: repository)),
            BlocProvider<DocFormBloc>(
                create: (context) => DocFormBloc(
                      initialState: DocumentFormInitial(),
                      docFirestoreBloc:
                          DocFirestoreBloc(repository: repository),
                    )),
          ], child: NewDoc()),
    },
    title: 'doc tracking',
    theme: ThemeData(
      primaryColorBrightness: Brightness.dark,
      primarySwatch: Colors.deepOrange,
      secondaryHeaderColor: Colors.deepOrange,
    ),
    home: App(docRepository: repository),
  ));
}
