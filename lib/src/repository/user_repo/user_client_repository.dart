import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

class UserClientRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /*
  *`??` is possible 'cause variables in dart are initialized as null.
  *  Here, if dependencies are not injected, then we instantiate
  *them ourselves. This configuration, as opposed to just creating new instances right
  *here allows to inject mock dependencies to test this class. This is good practice.
  * */
  UserClientRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    return getUser();
  }

  Future<FirebaseUser> signInWithCredentials(
      {@required String email, @required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return getUser();
  }

  Future<FirebaseUser> signUp(
      {@required String email, @required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return getUser();
  }

  Future<FirebaseUser> signOut() async {
    final user = await getUser();
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
    return user;
  }

  Future<bool> isSignedIn() async {
    final currentUser = await getUser();
    return currentUser != null;
  }

  Future<FirebaseUser> getUser() async {
    return await _firebaseAuth.currentUser();
  }
}
