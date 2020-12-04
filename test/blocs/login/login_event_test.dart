import 'package:doctracking/src/blocs/login/bloc/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginEvent', () {
    test('ensure LoginEmailChanged has expected props', () {
      final email = 'email';
      expect(LoginEmailChanged(email: email).props, [email]);
    });
    test('ensure LoginPasswordChanged has expected props', () {
      final password = 'password';
      expect(LoginPasswordChanged(password: password).props, [password]);
    });
    test('LoginWithGooglePressed has expected props', () {
      expect(LoginWithGooglePressed().props, []);
    });
    test('ensure LoginWithCredentialsPressed has expected props', () {
      expect(
          LoginWithCredentialsPressed(email: 'email', password: 'password')
              .props,
          ['email', 'password']);
    });
  });
}
