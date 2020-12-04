import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String _email;

  const LoginEmailChanged({@required String email})
      : assert(email != null),
        _email = email;
  @override
  List<Object> get props => [_email];
  @override
  String toString() {
    return 'LoginEmailChanged{email: $_email}';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String _password;

  const LoginPasswordChanged({@required String password})
      : assert(password != null),
        _password = password;
  @override
  List<Object> get props => [_password];

  @override
  String toString() {
    return 'LoginPasswordChanged {password: $_password}';
  }
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String _email;
  final String _password;

  const LoginWithCredentialsPressed(
      {@required String email, @required String password})
      : assert(email != null && password != null),
        _email = email,
        _password = password;

  @override
  List<Object> get props => [_email, _password];
  @override
  String toString() {
    return 'LoginWithCredentialsPressed{email: $_email, password: $_password}';
  }
}
