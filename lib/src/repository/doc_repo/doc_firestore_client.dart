import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

class DocFirestoreClient {
  final Firestore _firestoreInstance;
  final FirebaseUser _user;

  DocFirestoreClient(
      {@required FirebaseUser user, @required Firestore firestoreInstance})
      : assert(firestoreInstance != null),
        assert(user != null),
        _user = user,
        _firestoreInstance = firestoreInstance;

  //turns out the shortcut is to use current user's uuid. same idea of hashing password,
  //but google does that for us automatically. might be worth the effort to checkout some
  // mechanism behind google's hashing algorithm.
  Future<String> addDocument({@required Doc doc}) async {
    final data = doc.toMap();
    try {
      await _firestoreInstance
          .collection('${_user.uid}')
          .document('${doc.title.toLowerCase()}')
          .setData(data);
      return doc.title;
    } catch (_) {
      return ('adding a doc not working!');
    }
  }

  Future<void> deleteDocument({@required String title}) async {
    var collectionRef = _firestoreInstance.collection('${_user.uid}');
    try {
      await collectionRef
          .document('${title.toLowerCase()}')
          .snapshots()
          .forEach((doc) {
        if (doc['title'] == title.toLowerCase()) {
          collectionRef.document('${title.toLowerCase()}').delete();
          return;
        }
      });
      // TODO: HANDLE ERRORS BETTER.
    } catch (_) {
      return ("cant delete for some reason");
    }
  }

  Future<List<Doc>> getAllDocs() async {
    try {
      List<Doc> list = await _firestoreInstance
          .collection('${_user.uid}')
          .getDocuments()
          .then((QuerySnapshot snapshot) =>
              snapshot.documents.map((doc) => Doc.fromMap(doc.data)).toList());
      print('we did it: ${list.length}, ${list[0].title}');
      return list;
    } catch (error) {
      print('could not get the docs, ${error.toString()} happened');
      return null;
    }
  }

  Future<void> deleteAll() async {
    var collectionRef = _firestoreInstance.collection('${_user.uid}');
    try {
      return await collectionRef
          .getDocuments()
          .then((snapshot) => snapshot.documents.forEach((doc) {
                collectionRef.document('${doc.documentID}').delete();
              }));
    } catch (error) {
      print('an error happened${error.toString()}');
    }
  }
}
