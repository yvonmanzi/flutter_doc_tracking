import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationAuthenticated extends AuthenticationState {
  final String email;

  const AuthenticationAuthenticated(this.email);
  @override
  List<Object> get props => [email];
  @override
  String toString() {
    return 'Authenticated {email: $email}';
  }
}

class AuthenticationUnauthenticated extends AuthenticationState {}
