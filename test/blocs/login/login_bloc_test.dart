import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/login/bloc/login.dart';
import 'package:doctracking/src/blocs/login/bloc/validators.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

class ValidatorsMock extends Mock implements Validators {}

void main() {
  UserRepositoryMock userRepository;
  LoginBloc bloc;
  ValidatorsMock validator;
  /*
  * use setup function here to allow new instances for each test
  * */
  setUp(() {
    userRepository = UserRepositoryMock();
    bloc = LoginBloc(userRepository: userRepository);
    validator = ValidatorsMock();
  });
  tearDown(() {
    bloc?.close();
  });
  test('should assert if null', () {
    expect(() => LoginBloc(userRepository: null), throwsA(isAssertionError));
  });
  test('initial state is correct', () {
    expect(
        LoginState.initial(),
        LoginState(
          isEmailValid: true,
          isPasswordValid: true,
          isSubmitting: false,
          isSuccess: false,
          isFailure: false,
        ));
  });
  blocTest(
    'adding nothing does not emit any states',
    build: () => Future.value(bloc),
    expect: [],
  );
  blocTest('close does not emit new states', build: () {
    return Future.value(bloc);
  }, act: (bloc) {
    return bloc?.close();
  }, expect: []);

  group('LoginEmailChanged', () {
    /*
   * outputs the right states in the right order when LoginEmailChanged
   * event is added.
   * */
    blocTest(
        'streams the correct states when email changes and the email is valid',
        build: () {
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(LoginEmailChanged(email: 'email@example.com')),
        expect: [
          LoginState.initial().update(isSubmitting: true),
          LoginState.initial().update(isEmailValid: true),
        ]);
    /*
   * outputs the right states in the right order when LoginEmailChanged
   * event is added, but the email is not valid. email has to take 'email@example.com'
   * format
   * */
    blocTest(
        'streams the correct states when email changes and the email is invalid',
        build: () {
      when(validator.getIsValidEmail('email')).thenReturn(false);
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(LoginEmailChanged(email: 'email@'));
    }, expect: [
      //LoginState.initial(),
      LoginState.initial().update(isSubmitting: true),
      LoginState.initial().update(isEmailValid: false),
    ]);

    /*
    * password is valid. 'password' has at least 5 characters.
    * */
    blocTest('streams the right states when password changes and is valid',
        build: () {
          when(validator.getIsValidPassword('password')).thenReturn(true);
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(LoginPasswordChanged(password: 'password')),
        expect: [
          //LoginState.initial(),
          LoginState.initial().update(isSubmitting: true),
          LoginState.initial().update(isPasswordValid: true),
        ]);
    /*
    * password is invalid. password has to have at least 5 characters.
    * */
    blocTest('streams the right states when password changes and is invalid',
        build: () {
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(LoginPasswordChanged(password: 'pap')),
        expect: [
          LoginState.initial().update(isSubmitting: true),
          LoginState.initial().update(isPasswordValid: false)
        ]);
    /*
    * logging in with google succeeds
    * */
    blocTest(
        'streams the right states when LoginWithGooglePressed is added and succeeds',
        build: () {
          when(userRepository.signInWithGoogle())
              .thenAnswer((_) => Future.value());
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(LoginWithGooglePressed()),
        expect: [
          //LoginState.initial(),
          LoginState.initial().update(isSubmitting: true),
          LoginState.success(),
        ]);
    /*
    * logging in with google fails
    //TODO: mocking a future error is causing problems
    * */
    blocTest(
        'streams the right states when LoginWithGooglePressed is added and fails',
        build: () {
          when(userRepository.signInWithGoogle())
              .thenAnswer((_) => Future.error('error'));
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(LoginWithGooglePressed()),
        expect: [
          // LoginState.initial(),
          LoginState.initial().update(isSubmitting: true),
          LoginState.failure(),
        ]);
    /*
    * LoginWithCredentials succeeds
    * */
    blocTest(
        'streams the right states when LoginWithCredentials is added and succeeds',
        build: () {
          when(userRepository.signInWithCredentials(
                  email: 'email', password: 'password'))
              .thenAnswer((realInvocation) => Future.value());
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(
            LoginWithCredentialsPressed(email: 'email', password: 'password')),
        expect: [
          //LoginState.initial(),
          LoginState.initial().update(isSubmitting: true),
          LoginState.success(),
        ]);
    /*
    * LoginWithCredentials fails
    * */
    blocTest(
        'streams the right states when LoginWithCredentials is added and fails',
        build: () {
          when(userRepository.signInWithCredentials(
                  email: 'email', password: 'password'))
              .thenAnswer((realInvocation) => Future.error('fails'));
          /*userRepository
              .signInWithCredentials(email: 'email', password: 'password')
              .catchError((e) {
            //do nothing
          });*/
          return Future.value(bloc);
        },
        act: (bloc) => bloc.add(
            LoginWithCredentialsPressed(email: 'email', password: 'password')),
        expect: [
          //LoginState.initial(),
          LoginState.initial().update(isSubmitting: true),
          LoginState.failure(),
        ]);
  });
}
