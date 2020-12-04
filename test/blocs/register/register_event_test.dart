import 'package:doctracking/src/blocs/register/bloc/register.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterEvent', () {
    test('RegisterEmailChanged has correct props', () {
      expect(RegisterEmailChanged(email: 'email').props, ['email']);
    });
    test('RegisterPasswordChanged has correct props', () {
      expect(RegisterPasswordChanged(password: 'password').props, ['password']);
    });
    test('RegisterSubmitted has correct props', () {
      expect(RegisterSubmitted(email: 'email', password: 'password').props,
          ['email', 'password']);
    });
  });
}
