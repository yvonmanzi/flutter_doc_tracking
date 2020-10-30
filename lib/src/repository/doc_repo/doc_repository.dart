import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../models/doc.dart';
import '../doc_repo/doc_firestore_client.dart';

class DocRepository {
  final DocFirestoreClient _docFirestoreClient =
      DocFirestoreClient(firestoreInstance: Firestore.instance);

  Future<void> addDocument({@required String title, String expiration}) async {
    return await _docFirestoreClient.addDocument(
        title: title, expiration: expiration);
  }

  Future<void> deleteDocument({@required String title}) async {
    await _docFirestoreClient.deleteDocument(title: title);
  }

  Future<List<Doc>> getAllDocuments() async {
    return await _docFirestoreClient.getAllDocs();
  }

  Future<void> deleteAll() async {
    await _docFirestoreClient.deleteAll();
  }
}
