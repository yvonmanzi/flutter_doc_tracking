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
  try {
    try {
      try {
        try {
          group('UserClientRepository', () {
            FirebaseAuthMock firebaseAuth;
            GoogleSignInMock googleSignIn;
            UserClientRepository userClientRepository;
            FirebaseUserMock currentFirebaseUser;
            GoogleSignInAuthenticationMock googleSignInAuth;
            GoogleSignInAccountMock googleSignInAccount;
            AuthResultMock authResult;

            // Use `setup` to initialize dependencies before every test
            setUp(() {
              firebaseAuth = FirebaseAuthMock();
              googleSignIn = GoogleSignInMock();
              userClientRepository = UserClientRepository(
                  firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
              currentFirebaseUser = FirebaseUserMock();
              googleSignInAuth = GoogleSignInAuthenticationMock();
              googleSignInAccount = GoogleSignInAccountMock();
              authResult = AuthResultMock();
            });

            group("signInWithGoogle", () {
              test('signing in with google returns firebase user', () async {
                //mock methods that apply to all the group
                when(googleSignIn.signIn()).thenAnswer((_) =>
                    Future<GoogleSignInAccountMock>.value(googleSignInAccount));
                when(googleSignInAccount.authentication).thenAnswer((_) =>
                    Future<GoogleSignInAuthenticationMock>.value(
                        googleSignInAuth));
                when(firebaseAuth.currentUser()).thenAnswer(
                    (_) => Future<FirebaseUserMock>.value(currentFirebaseUser));

                expect(await userClientRepository.signInWithGoogle(),
                    currentFirebaseUser);
                // verify these methods were called only once.
                verify(googleSignIn.signIn()).called(1);
                verify(googleSignInAccount.authentication).called(1);
              });
            });

            /*
            *
            * */
            group('signUp', () {
              test('returns `currentFirebaseUser`if `signUp` succeeds',
                  () async {
                final email = 'email@example.com';
                final password = 'password';
// Mock the method call
                when(firebaseAuth.createUserWithEmailAndPassword(
                        email: email, password: password))
                    .thenAnswer((_) => Future.value(authResult));
                when(firebaseAuth.currentUser()).thenAnswer(
                    (_) => Future<FirebaseUserMock>.value(currentFirebaseUser));

// Call the method and expect `currentFirebaseUser` to be returned.
                expect(
                    await userClientRepository.signUp(
                        email: email, password: password),
                    currentFirebaseUser);
              });

              test('throws `ArgumentError`if `signUp` fails', () async {
                final email = 'wrong_email.com';
                final password = 'password';
// Mock the method call
                when(firebaseAuth.createUserWithEmailAndPassword(
                        email: email, password: password))
                    .thenAnswer((_) => Future<AuthResultMock>.error(
                        ArgumentError('error signing up')));
// Call the method and expect `currentFirebaseUser` to be returned.
                expect(
                    await userClientRepository.signUp(
                        email: email, password: password),
                    throwsArgumentError);
              });
            });
            /*
          *
          * */
            group('signInWithCredentials', () {
              test('signing in with credentials returns a Firebase user',
                  () async {
                final email = 'email@example.com';
                final password = 'password';

                when(firebaseAuth.signInWithEmailAndPassword(
                        email: email, password: password))
                    .thenAnswer((_) => Future.value(authResult));

                expect(
                    await userClientRepository.signInWithCredentials(
                        email: email, password: password),
                    currentFirebaseUser);
              });
            });

/*

* */
            group('isSignedIn', () {
              test(
                  'is signed in returns true iff FirebaseAuth has a user.'
                  ' Otherwise returns false', () async {
                expect(await userClientRepository.isSignedIn(), true);
                when(firebaseAuth.currentUser())
                    .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
                expect(await userClientRepository.isSignedIn(), false);
              });
            });
            group('getUser', () {
              test('get user returns the current firebase user', () async {
                expect(
                    await userClientRepository.getUser(), currentFirebaseUser);
                when(firebaseAuth.currentUser())
                    .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
                expect(await userClientRepository.getUser(), null);
              });
            });
          });
        } catch (e, s) {
          print(s);
        }
      } catch (e, s) {
        print(s);
      }
    } catch (e, s) {
      print(s);
    }
  } catch (e, s) {
    print(s);
  }

  /*
  *
  * */
}
