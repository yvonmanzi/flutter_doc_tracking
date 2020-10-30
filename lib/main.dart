import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/bloc/authentication/authentication.dart';
import 'package:doctracking/src/bloc/doc_firestore/doc_firestore_bloc.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:doctracking/src/ui/app.dart';
import 'package:doctracking/src/ui/new_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './src/bloc/doc_form/doc_form.dart';
import './src/repository/user_repo/user_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final firestoreInstance = Firestore.instance;
  final docFirestoreClient =
      DocFirestoreClient(firestoreInstance: firestoreInstance);
  final docRepository = DocRepository(docFirestoreClient: docFirestoreClient);
  final userRepository = UserRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
      ),
      BlocProvider<DocFirestoreBloc>(
        create: (context) => DocFirestoreBloc(repository: docRepository),
      )
    ],
    child: MaterialApp(
      routes: {
        // Send two blocks down the new_doc widget
        '/new_doc': (BuildContext context) => MultiBlocProvider(providers: [
              BlocProvider<DocFirestoreBloc>(
                  create: (context) =>
                      DocFirestoreBloc(repository: docRepository)),
              BlocProvider<DocFormBloc>(
                  create: (context) => DocFormBloc(
                        initialState: DocumentFormInitial(),
                        docFirestoreBloc:
                            DocFirestoreBloc(repository: docRepository),
                      )),
            ], child: NewDoc()),
      },
      title: 'doc tracking',
      theme: ThemeData(
        primaryColorBrightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        secondaryHeaderColor: Colors.deepOrange,
      ),
      home: App(),
    ),
  ));
}
