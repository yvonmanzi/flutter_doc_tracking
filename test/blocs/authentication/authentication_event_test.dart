import 'package:doctracking/src/blocs/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Authentication events', () {
    test('AuthenticationAppStarted returns correct props', () {
      expect(AuthenticationAppStarted().props, []);
    });
    test('AuthenticationLoggedIn returns correct props', () {
      expect(AuthenticationLoggedIn().props, []);
    });
    test('AuthenticationLoggedOUt returns correct props', () {
      expect(AuthenticationLoggedOut().props, []);
    });
  });
}
