import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'user_client_repository.dart';

class UserRepository {
  final UserClientRepository _userClientRepository;
  UserRepository({@required UserClientRepository userClientRepository})
      : assert(userClientRepository != null),
        _userClientRepository = userClientRepository;

  Future<FirebaseUser> signInWithGoogle() async {
    return await _userClientRepository.signInWithGoogle();
  }

  Future<FirebaseUser> signInWithCredentials(
      {@required String email, @required String password}) async {
    return await _userClientRepository.signInWithCredentials(
        email: email, password: password);
  }

  Future<FirebaseUser> signUp(
      {@required String email, @required String password}) async {
    return await _userClientRepository.signUp(email: email, password: email);
  }

  Future<FirebaseUser> signOut() async {
    return await _userClientRepository.signOut();
  }

  Future<bool> isSignedIn() async {
    return await _userClientRepository.isSignedIn();
  }

  Future<FirebaseUser> getUser() async {
    return await _userClientRepository.getUser();
  }
}
