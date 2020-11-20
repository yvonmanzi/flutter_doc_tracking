import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/authentication/authentication.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

void main() {
  AuthenticationBloc authenticationBloc;
  UserRepositoryMock userRepository;
  FirebaseUserMock currentUser;
  setUp(() {
    userRepository = UserRepositoryMock();
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    currentUser = FirebaseUserMock();
    print("$currentUser");
  });
  tearDown(() {
    authenticationBloc?.close();
  });
  test('should assert if null', () {
    expect(AuthenticationBloc(userRepository: null), throwsA(isAssertionError));
  });
  /*
    * Test to ensure our initial state is what we expect.
    * */
  test('initial state is correct', () {
    expect(authenticationBloc.state, AuthenticationUninitialized());
  });
  /*
    * Test to ensure closing bloc doesn't emit new states
    * */
  test('close does not emit new states', () {
    expectLater(authenticationBloc,
        emitsInOrder([AuthenticationUninitialized(), emitsDone]));
    authenticationBloc.close();
  });

  group('AuthenticationBloc', () {
    /*
* Test to ensure 'AppStarted' event emits the correct states
*  in expected order when user is signed in.
* */
    blocTest(
        'emits [AuthenticationUninitialized, AuthenticationAuthenticated] '
        'when user is signed in', build: () async {
      when(userRepository.getUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(currentUser));
      when(userRepository.isSignedIn()).thenAnswer((_) => Future.value(true));

      return Future.value(authenticationBloc);
    }, act: (bloc) async {
      currentUser = await userRepository.getUser();
      print("$currentUser");
      return bloc.add(AuthenticationAppStarted());
    }, expect: [
      AuthenticationUninitialized(),
      //AuthenticationLoading(),
      AuthenticationAuthenticated(currentUser: currentUser)
    ]);
    /*
      * Test to ensure AppStarted even emits the correct states in the expected order when user is not signed in
      * */
    blocTest(
        'emits[AuthenticationUninitialized, AuthenticationUnauthenticated()] '
        'when event AuthenticationAppStarted is added and user is not signed in',
        build: () {
          when(userRepository.isSignedIn())
              .thenAnswer((_) => Future.value(false));

          //when(userRepository.getUser())
          //.thenAnswer((_) => Future.value(currentUser));
          return Future.value(authenticationBloc);
        },
        act: (bloc) => bloc.add(AuthenticationAppStarted()),
        expect: [
          AuthenticationUninitialized(),
          AuthenticationLoading(),
          AuthenticationUnauthenticated()
        ]);
  });
}
