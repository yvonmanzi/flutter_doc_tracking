import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
  @override
  String toString() {
    return super.toString();
  }
}

class AuthenticationAppStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationLoggedOut extends AuthenticationEvent {}
