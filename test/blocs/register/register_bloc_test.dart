import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/register/bloc/register.dart';
import 'package:doctracking/src/repository/user_repo/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  group(RegisterBloc, () {
    UserRepository userRepository;
    RegisterBloc bloc;

    setUp(() {
      userRepository = UserRepositoryMock();
      bloc = RegisterBloc(userRepository: userRepository);
    });
    tearDown(() {
      bloc?.close();
    });
    test('throws AssertionError if `userRepository` is null', () {
      expect(
          () => RegisterBloc(userRepository: null), throwsA(isAssertionError));
    });
    blocTest(
      'adding nothing does not emit any states',
      build: () => Future.value(bloc),
      expect: [],
    );

    /// Initial state is expected to be `RegisterState.initial()`
    test('initial state is correct', () {
      expect(bloc.state, RegisterState.initial());
    });
    blocTest('close does not emit new states', build: () {
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc?.close();
    }, expect: []);

    group('RegisterEmailChanged', () {
      /// emits `[Register.update(isEmailValid:true)]`
      /// when RegisterEmailChanged is added and email is valid
      blocTest('registration email changed',
          build: () {
            return Future.value(bloc);
          },
          act: (bloc) =>
              bloc.add(RegisterEmailChanged(email: 'email@example.com')),
          expect: [
            RegisterState.initial().update(isEmailValid: true),
          ]);
    });
    group('RegisterPasswordChanged', () {});
    group('RegisterSubmitted', () {});
  });
}
