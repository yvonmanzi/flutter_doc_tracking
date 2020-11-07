import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../models/doc.dart';
import '../doc_repo/doc_firestore_client.dart';

class DocRepository {
  final DocFirestoreClient _docFirestoreClient;
  final FirebaseUser _user;
  DocRepository(
      {@required FirebaseUser user,
      @required DocFirestoreClient docFirestoreClient})
      : assert(docFirestoreClient != null),
        assert(user != null),
        _docFirestoreClient = docFirestoreClient,
        _user = user;

  Future<void> addDocument({@required String title, String expiration}) async {
    return await _docFirestoreClient.addDocument(
        user: _user, title: title, expiration: expiration);
  }

  Future<void> deleteDocument({@required String title}) async {
    await _docFirestoreClient.deleteDocument(user: _user, title: title);
  }

  Future<List<Doc>> getAllDocuments() async {
    return await _docFirestoreClient.getAllDocs(user: _user);
  }

  Future<void> deleteAll() async {
    await _docFirestoreClient.deleteAll(user: _user);
  }
}
