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
      yield* _mapLoginEmailChangedToState(event.props.first);
    else if (event is LoginPasswordChanged)
      yield* _mapLoginPasswordToState(event.props.first);
    else if (event is LoginWithGooglePressed)
      yield* _mapLoginWithGooglePressedToState();
    else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
          email: event.props.first, password: event.props[1]);
    }
  }

  Stream<LoginState> _mapLoginEmailChangedToState(String email) async* {
    yield state.update(isSubmitting: true);
    final Validators validator = Validators();
    yield state.update(isEmailValid: validator.getIsValidEmail(email));
  }

  Stream<LoginState> _mapLoginPasswordToState(String password) async* {
    yield state.update(isSubmitting: true);
    final Validators validator = Validators();
    yield state.update(
      isPasswordValid: validator.getIsValidPassword(password),
    );
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    yield state.update(isSubmitting: true);
    try {
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield state.update(isSubmitting: true);
    try {
      /*
      * this is really the power of testing. Initially I was forgetting
      * this `await` and so my code was basically incorrect. I got frustrated testing
      * this but sooner or later this bug would have come to haunt me. Now, I caught it sooner
      * than later.
      * */
      await _userRepository.signInWithCredentials(
          email: email, password: password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
