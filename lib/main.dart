import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './src/blocs/authentication/authentication.dart';
import './src/blocs/doc_firestore/doc_firestore.dart';
import './src/blocs/doc_form/doc_form.dart';
import './src/blocs/login/ui/login_screen.dart';
import './src/repository/doc_repo/doc_repository.dart';
import './src/repository/user_repo/user_cient_repository.dart';
import './src/ui/app.dart';
import './src/ui/new_doc.dart';
import './src/ui/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final docRepository = DocRepository();
  final userRepository = UserRepository();

  runApp(BlocProvider<AuthenticationBloc>(
    // Create the bloc and instantly add an event(AuthenticationAppStarted)
    create: (context) => AuthenticationBloc(userRepository: userRepository)
      ..add(AuthenticationAppStarted()),
    child: MaterialApp(
        routes: {
          '/new_doc': (BuildContext context) => BlocProvider<DocFormBloc>(
              create: (context) => DocFormBloc(
                  docFirestoreBloc:
                      DocFirestoreBloc(repository: docRepository)),
              child: NewDoc()),
        },
        title: 'doc tracking',
        theme: ThemeData(
          primaryColorBrightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
          secondaryHeaderColor: Colors.deepOrange,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) return SplashScreen();
            if (state is AuthenticationAuthenticated)
              return BlocProvider<DocFirestoreBloc>(
                  create: (context) =>
                      DocFirestoreBloc(repository: docRepository),
                  child: App());
            else
              return LoginScreen();
          },
        )),
  ));
}
