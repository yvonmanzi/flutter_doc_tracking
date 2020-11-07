import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final FirebaseUser _currentUser;

  const AuthenticationAuthenticated({@required FirebaseUser currentUser})
      : assert(currentUser != null),
        _currentUser = currentUser;
  @override
  List<Object> get props => [_currentUser];
  @override
  String toString() {
    return 'Authenticated {email: ${_currentUser.uid}}';
  }
}

class AuthenticationUnauthenticated extends AuthenticationState {}
