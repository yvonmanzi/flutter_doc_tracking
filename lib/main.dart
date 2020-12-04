import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/blocs/doc_firestore/doc_firestore.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './src/blocs/authentication/authentication.dart';
import './src/blocs/login/ui/login_screen.dart';
import './src/repository/user_repo/user_client_repository.dart';
import './src/repository/user_repo/user_repository.dart';
import './src/ui/app.dart';
import './src/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final userRepository =
      UserRepository(userClientRepository: UserClientRepository());

  runApp(BlocProvider<AuthenticationBloc>(
    /*
    * Create the authentication bloc,
    * and instantly add an event(AuthenticationAppStarted)
    * */
    create: (context) => AuthenticationBloc(userRepository: userRepository)
      ..add(AuthenticationAppStarted()),
    child: MaterialApp(
        title: 'doc tracking',
        theme: ThemeData(
          primaryColorBrightness: Brightness.dark,
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.blueAccent,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) return SplashScreen();

            if (state is AuthenticationAuthenticated)
              return BlocProvider<DocFirestoreBloc>(
                  create: (context) {
                    var user = state.props.first;
                    var docRepository = DocRepository(
                        docFirestoreClient: DocFirestoreClient(
                            user: user, firestoreInstance: Firestore.instance));
                    return DocFirestoreBloc(repository: docRepository);
                  },
                  child: App());
            else
              return LoginScreen(userRepository: userRepository);
          },
        )),
  ));
}
