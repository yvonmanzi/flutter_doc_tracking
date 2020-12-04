import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class LoginState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid && isPasswordValid;

  LoginState({
    @required this.isPasswordValid,
    @required this.isEmailValid,
    @required this.isFailure,
    @required this.isSubmitting,
    @required this.isSuccess,
  });

  factory LoginState.initial() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  LoginState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitting,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSuccess: false,
      isFailure: false,
      isSubmitting: isSubmitting,
    );
  }

  LoginState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }

  @override
  List<Object> get props =>
      [isEmailValid, isPasswordValid, isSubmitting, isSuccess, isFailure];

  @override
  bool get stringify => true;
}
