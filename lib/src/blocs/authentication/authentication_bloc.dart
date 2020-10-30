import 'package:bloc/bloc.dart';
import 'package:doctracking/src/blocs/authentication/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../repository/user_repo/user_cient_repository.dart';
import 'authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationAppStarted) {
      yield* _mapAuthenticationAppStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  _mapAuthenticationAppStartedToState() async* {
    final isSignedIn = await _userRepository.isSignedIn();
    if (isSignedIn) {
      final name = await _userRepository.getUser();
      yield AuthenticationAuthenticated(name);
    } else {
      yield AuthenticationUnauthenticated();
    }
  }

  _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationAuthenticated(await _userRepository.getUser());
  }

  _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationUnauthenticated();
    _userRepository.signOut();
  }
}
