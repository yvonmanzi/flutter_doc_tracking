import 'package:doctracking/src/repository/user_repo/user_client_repository.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserClientRepositoryMock extends Mock implements UserClientRepository {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  group('UserRepository', () {
    UserClientRepositoryMock userClientRepository;
    UserRepository userRepository;
    FirebaseUserMock firebaseUser;
    final email = 'email@example.com';
    final password = 'password';
    setUp(() {
      firebaseUser = FirebaseUserMock();
      userClientRepository = UserClientRepositoryMock();
      userRepository =
          UserRepository(userClientRepository: userClientRepository);
      firebaseUser = FirebaseUserMock();
    });

    test('throws error if userClientRepository is null', () {
      expect(() => UserRepository(userClientRepository: null),
          throwsA(isAssertionError));
    });

    /// Test `signWithGoogle`
    group('signWithGoogle', () {
      test('should call signInWithGoogle from UserClientRepository', () async {
        when(userClientRepository.signInWithGoogle())
            .thenAnswer((realInvocation) => Future.value(firebaseUser));
        expect(await userRepository.signInWithGoogle(), firebaseUser);
      });
    });

    /// Test `signWithCredentials`
    group('signWithCredentials', () {
      test('should call signWithCredentials from UserClientRepository',
          () async {
        when(userClientRepository.signInWithCredentials(
                email: email, password: password))
            .thenAnswer((realInvocation) => Future.value(firebaseUser));

        expect(
            await userRepository.signInWithCredentials(
                email: email, password: password),
            firebaseUser);
        verify(userRepository.signInWithCredentials(
                email: email, password: password))
            .called(1);
      });
    });

    /// Test `signUp`
    group('signUp', () {
      test('should call signUp UserClientRepository', () async {
        when(userClientRepository.signUp(email: email, password: password))
            .thenAnswer((realInvocation) => Future.value(firebaseUser));

        expect(await userRepository.signUp(email: email, password: password),
            firebaseUser);
        verify(userRepository.signUp(email: email, password: password))
            .called(1);
      });
    });

    /// Test `signOut`
    group('signOut', () {
      test(
          'calls signOut from UserClientRepository and returns current firebaseUser',
          () async {
        when(userClientRepository.signOut())
            .thenAnswer((realInvocation) => Future.value(firebaseUser));
        expect(await userRepository.signOut(), firebaseUser);

        verify(userRepository.signOut()).called(1);
      });
    });

    /// Test `isSignedIn`
    group('isSignedIn', () {
      test(
          'isSignedIn returns true from UserClientRepository if a user is signed in',
          () async {
        when(userClientRepository.isSignedIn())
            .thenAnswer((realInvocation) => Future.value(true));
        expect(await userRepository.isSignedIn(), true);
        verify(userRepository.isSignedIn()).called(1);
      });
      test(
          'isSignedIn returns false from UserClientRepository if no user is signed in',
          () async {
        when(userClientRepository.isSignedIn())
            .thenAnswer((realInvocation) => Future.value(false));
        expect(await userRepository.isSignedIn(), false);
        verify(userRepository.isSignedIn()).called(1);
      });
    });
  });
}
