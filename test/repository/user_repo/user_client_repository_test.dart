import 'package:doctracking/src/repository/user_repo/user_client_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class GoogleSignInMock extends Mock implements GoogleSignIn {}

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}

class AuthResultMock extends Mock implements AuthResult {}

class GoogleSignInAuthenticationMock extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  final firebaseAuth = FirebaseAuthMock();
  final googleSignIn = GoogleSignInMock();
  final userClientRepository = UserClientRepository(
      firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
  final currentFirebaseUser = FirebaseUserMock();
  final googleSignInAuth = GoogleSignInAuthenticationMock();
  final googleSignInAccount = GoogleSignInAccountMock();
  final authResult = AuthResultMock();

  group("user client repository", () {
    //mocks that apply to all the tests in the group
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(currentFirebaseUser));
    test('signing in with google returns firebase user', () async {
      // mock method calls
      when(googleSignIn.signIn()).thenAnswer(
          (_) => Future<GoogleSignInAccountMock>.value(googleSignInAccount));
      when(googleSignInAccount.authentication).thenAnswer((realInvocation) =>
          Future<GoogleSignInAuthenticationMock>.value(googleSignInAuth));
      expect(
          await userClientRepository.signInWithGoogle(), currentFirebaseUser);
      // verify these methods were called only once.
      verify(googleSignIn.signIn()).called(1);
      print('$currentFirebaseUser');
      verify(googleSignInAccount.authentication).called(1);
    });

    /*
    *
    * */

    test('sign up with email and password', () async {
      final email = 'email@example.com';
      final password = 'password';

      when(firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((realInvocation) => Future.value(authResult));

      expect(
          await userClientRepository.signUp(email: email, password: password),
          currentFirebaseUser);
    });
  });
  /*
  *
  * */

  test('signing in with credentials returns a Firebase user', () async {
    final email = 'email@example.com';
    final password = 'password';

    when(firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .thenAnswer((realInvocation) => Future.value(authResult));

    expect(
        await userClientRepository.signInWithCredentials(
            email: email, password: password),
        currentFirebaseUser);
  });
/*

* */
  test(
      'is signed in returns true iff FirebaseAuth has a user.'
      ' Otherwise returns false', () async {
    expect(await userClientRepository.isSignedIn(), true);
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
    expect(await userClientRepository.isSignedIn(), false);
  });

  /*
  *
  * */
  test('get user returns the current firebase user', () async {
    expect(await userClientRepository.getUser(), currentFirebaseUser);
    when(firebaseAuth.currentUser())
        .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
    expect(await userClientRepository.getUser(), null);
  });
}
