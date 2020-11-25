import 'package:doctracking/src/repository/user_repo/user_client_repository.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserClientRepositoryMock extends Mock implements UserClientRepository {}

void main() {
  final UserClientRepositoryMock userClientRepository =
      UserClientRepositoryMock();
  final UserRepository userRepository =
      UserRepository(userClientRepository: userClientRepository);
  test('assert if null', () {
    expect(() => UserRepository(userClientRepository: null),
        throwsA(isAssertionError));
  });
  group('User repository', () {
    final email = 'email@example.com';
    final password = 'password';
    test('should call sign in with google from UserClientRepository', () {
      when(userRepository.signInWithGoogle())
          .thenAnswer((realInvocation) => Future.value());
      userRepository.signInWithGoogle();
      verify(userRepository.signInWithGoogle()).called(1);
    });
    test('should call signWithCredentials from UserClientRepository', () {
      when(userRepository.signInWithCredentials(
          email: email, password: password));

      userRepository.signInWithCredentials(email: email, password: password);

      verify(userRepository.signInWithCredentials(
              email: email, password: password))
          .called(1);
    });
    test('should call signUp UserClientRepository', () {
      when(userRepository.signUp(email: email, password: password))
          .thenAnswer((realInvocation) => Future.value());
      userRepository.signUp(email: email, password: password);
      verify(userRepository.signUp(email: email, password: password)).called(1);
    });
    test('should call signOut from UserClientRepository', () {
      when(userRepository.signOut())
          .thenAnswer((realInvocation) => Future.value());
      userRepository.signOut();

      verify(userRepository.signOut()).called(1);
    });

    test('isSignedIn returns true from UserClientRepository', () {
      when(userRepository.isSignedIn())
          .thenAnswer((realInvocation) => Future.value(true));
      expect(userRepository.isSignedIn(), true);
      verify(userRepository.isSignedIn()).called(1);
    });
  });
}
