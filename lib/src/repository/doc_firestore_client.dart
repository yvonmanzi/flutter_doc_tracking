import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class DocFirestoreClient {
  final Firestore _firestoreInstance;

  DocFirestoreClient({@required Firestore firestoreInstance})
      : assert(firestoreInstance != null),
        _firestoreInstance = firestoreInstance;

  Future<String> addDocument(
      {int id, @required String title, @required String expiration}) async {
    final data = {'title': title, 'expiration': expiration};
    try {
      await _firestoreInstance
          .collection('docs')
          .document('${title.toLowerCase()}')
          .setData(data);
      return title;
    } catch (_) {
      return ('adding a doc not working!');
    }
  }

  Future<String> deleteDocument({@required String title}) async {
    try {
      await _firestoreInstance
          .collection('docs')
          .document('${title.toLowerCase()}')
          .delete();
      return title;
    } catch (_) {
      return ("cant delete for some reason");
    }
  }

  Future<List<Doc>> getAllDocs() async {
    try {
      return await _firestoreInstance.collection('docs').getDocuments().then(
          (QuerySnapshot snapshot) =>
              snapshot.documents.map((doc) => Doc.fromMap(doc.data)).toList());
    } catch (_) {
      print('could not get the docs');
      return null;
    }
  }

  Future<void> deleteAll() async {
    try {
      return await _firestoreInstance.collection('docs').getDocuments().then(
          (value) => value.documents
              .map((doc) => deleteDocument(title: doc.data['title'])));
    } catch (error) {
      print('an error happened${error.toString()}');
    }
  }
}
