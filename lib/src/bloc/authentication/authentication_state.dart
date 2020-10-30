import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String userName;

  const AuthenticationAuthenticated(this.userName);
  @override
  List<Object> get props => [userName];
  @override
  String toString() {
    // TODO: implement toString
    return 'Authenticated {userName: $userName}';
  }
}

class AuthenticationUnauthenticated extends AuthenticationState {}
