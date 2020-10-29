import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({@required this.email});
  @override
  // TODO: implement props
  List<Object> get props => [email];
  @override
  String toString() {
    return 'LoginEmailChanged{email: $email}';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({@required this.password});
  @override
  // TODO: implement props
  List<Object> get props => [password];

  @override
  String toString() {
    // TODO: implement toString
    return 'LoginPasswordChanged {password: $password}';
  }
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed(
      {@required this.email, @required this.password});

  @override
  // TODO: implement props
  List<Object> get props => [email, password];
  @override
  String toString() {
    // TODO: implement toString
    return 'LoginWithCredentialsPressed{email: $email, password: $password}';
  }
}
