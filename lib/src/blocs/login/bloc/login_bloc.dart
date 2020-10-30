import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../src/repository/user_repo/user_repository.dart';
import 'login.dart';
import 'validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged)
      yield* _mapLoginEmailChangedToState(event.email);
    else if (event is LoginPasswordChanged)
      yield* _mapLoginPasswordToState(event.password);
    else if (event is LoginWithGooglePressed)
      yield* _mapLoginWithGooglePressedToState();
    else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    try {
      _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
