import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';

class DocFirestoreClient {
  final Firestore _firestoreInstance;
  final FirebaseUser _user;

  DocFirestoreClient({@required FirebaseUser user, Firestore firestoreInstance})
      : assert(user != null),
        _user = user,
        _firestoreInstance = firestoreInstance ?? Firestore.instance;

  /*turns out the shortcut is to use current user's uuid. same idea of hashing password,
  but google does that for us automatically. might be worth the effort to checkout some
  mechanism behind google's hashing algorithm.*/

  /// Add document to the db
  ///
  /// Arguments
  ///
  /// * `doc` - document to be added to the db
  ///
  /// Returns
  ///
  /// * `doc.title` - the title of the document just added to the db
  Future<String> addDocument({@required Doc doc}) async {
    final data = doc.toMap();
    await _firestoreInstance
        .collection('${_user.uid}')
        .document('${doc.title.toLowerCase()}')
        .setData(data);
    return doc.title;
  }

  /// Delete a document from the db
  ///
  /// Arguments
  ///
  /// * `title` - a title of the document to be deleted
  ///
  /// Returns
  ///
  /// * `title` - a title of the deleted document
  Future<String> deleteDocument({@required String title}) async {
    var collectionRef = _firestoreInstance.collection('${_user.uid}');
    await collectionRef.getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((document) {
              if (document.data['title'] == title.toLowerCase()) {
                collectionRef.document('${title.toLowerCase()}').delete();
              } else {
                return null;
              }
            }));
    return title;
  }

  /// Get all documents from the db
  ///
  /// Returns
  ///
  /// * `list` - a list of all documents currently in the database
  Future<List<Doc>> getAllDocs() async {
    List<Doc> list = await _firestoreInstance
        .collection('${_user.uid}')
        .getDocuments()
        .then((QuerySnapshot snapshot) =>
            snapshot.documents.map((doc) => Doc.fromMap(doc.data)).toList());
    return list;
  }

  /// Delete all documents in the db
  ///
  /// Returns
  ///
  /// * `list` - a list of all deleted documents
  Future<List<Doc>> deleteAll() async {
    var collectionRef = _firestoreInstance.collection('${_user.uid}');
    var list = List<Doc>();
    await collectionRef.getDocuments().then(
        (QuerySnapshot snapshot) => snapshot.documents.forEach((document) {
              list.add(Doc.fromMap(document.data));
              collectionRef.document('${document.data['title']}').delete();
            }));
    return list;
  }
}
