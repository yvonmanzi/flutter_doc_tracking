import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/login/bloc/login.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  group('LoginBloc', () {
    UserRepositoryMock userRepository;
    LoginBloc bloc;

    ///Use setup function here to allow new instances for each test
    setUp(() {
      userRepository = UserRepositoryMock();
      bloc = LoginBloc(userRepository: userRepository);
    });
    tearDown(() {
      bloc?.close();
    });
    test('should assert if `userRepository` is null', () {
      expect(() => LoginBloc(userRepository: null), throwsA(isAssertionError));
    });
    test('initial state is correct', () {
      expect(
        bloc.state,
        LoginState.initial(),
      );
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
      ////emits [LoginState.initial, LoginState.initial.update]
      // when LoginEmailChanged is added and Validators.isEmailValid return true
      blocTest('valid email',
          build: () {
            return Future.value(bloc);
          },
          act: (bloc) =>
              bloc.add(LoginEmailChanged(email: 'email@example.com')),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.initial().update(isEmailValid: true),
          ]);

      ///emits [ LoginState.initial().update(isSubmitting: true),
      ///LoginState.initial().update(isEmailValid: false)]
      /// when LoginEmailChanged is added and Validators.isEmailValid return false
      blocTest('invalid email. Email has to take email@example.com', build: () {
        return Future.value(bloc);
      }, act: (bloc) {
        return bloc.add(LoginEmailChanged(email: 'email@'));
      }, expect: [
        LoginState.initial().update(isSubmitting: true),
        LoginState.initial().update(isEmailValid: false),
      ]);
    });
    group('LoginPasswordChanged', () {
      ///emits [`LoginState.initial().update(isSubmitting: true)`,
      ///`LoginState.initial().update(isPasswordValid: true)`]
      ///when LoginPasswordChanged is added and `Validators.isPasswordValid` returns true
      blocTest('Password is valid. Password has at least 5 characters',
          build: () {
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginPasswordChanged(password: 'password')),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.initial().update(isPasswordValid: true),
          ]);

      ///emits `[LoginState.initial().update(isSubmitting: true)`,
      ///`LoginState.initial().update(isPasswordValid: true)`]
      /// when LoginPasswordChanged is added and `Validators.isPasswordValid` returns false
      blocTest(
          'Password is invalid. Password has to have at least 5 characters',
          build: () {
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginPasswordChanged(password: 'pap')),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.initial().update(isPasswordValid: false)
          ]);
    });

    group('LoginWithGoogle', () {
      ///emits [LoginState.initial().update(isSubmitting:true), LoginState.success()]
      /// when LoginWithGooglePressed is added and succeeds
      blocTest('Logging in with google succeeds',
          build: () {
            when(userRepository.signInWithGoogle())
                .thenAnswer((_) => Future.value());
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginWithGooglePressed()),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.success(),
          ]);

      ///emits `[LoginState.initial().update(isSubmitting: true),LoginState.failure()]`
      /// when `LoginWithGoogle` is added and fails
      blocTest('Logging in with google fails',
          build: () {
            when(userRepository.signInWithGoogle())
                .thenAnswer((_) => Future.error('error'));
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginWithGooglePressed()),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.failure(),
          ]);
    });
    group('LoginWithCredentials', () {
      ///emits `[LoginState.initial().update(isSubmitting: true),LoginState.success()]`
      ///when LoginWithCredentials is added and succeeds
      blocTest('Logging in with credentials succeeds',
          build: () {
            when(userRepository.signInWithCredentials(
                    email: 'email', password: 'password'))
                .thenAnswer((realInvocation) => Future.value());
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: 'email', password: 'password')),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.success(),
          ]);

      ///emits `[LoginState.initial().update(isSubmitting: true),LoginState.failure()]`
      /// when LoginWithCredentials is added and fails
      blocTest('Logging in with credentials fails',
          build: () {
            when(userRepository.signInWithCredentials(
                    email: 'email', password: 'password'))
                .thenAnswer((realInvocation) => Future.error('fails'));
            return Future.value(bloc);
          },
          act: (bloc) => bloc.add(LoginWithCredentialsPressed(
              email: 'email', password: 'password')),
          expect: [
            LoginState.initial().update(isSubmitting: true),
            LoginState.failure(),
          ]);
    });
  });
}
