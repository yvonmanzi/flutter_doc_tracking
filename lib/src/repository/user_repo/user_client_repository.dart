import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

// this ?? is possible 'cause variables in dart are initialized as null
//cause they are all objects.  here, if they are not injected, then we instantiate
  //them ourselves. This configuration, as opposed to just creating new instances right
//  here and now allows to inject mock dependencies to test things. so its good practice I think. investiagae later.
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

// TODO: devise a better way to handle errors.
  Future<FirebaseUser> signInWithCredentials(String email, String password) {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _firebaseAuth.currentUser();
    } catch (e) {
      return e;
    }
    /*if(e.code == 'user-not-found'){
      print('no user found for that email');}
      else if (e.dode == 'wrong-password'){
        print('wrong password provided for that user');
      }
    * */
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    //TODO: this current user has a uid attribute.
    //we may use this uid to identify each user's collection of docs
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
