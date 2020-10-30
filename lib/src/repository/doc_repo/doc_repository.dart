import 'package:doctracking/src/models/doc.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:meta/meta.dart';

class DocRepository {
  final DocFirestoreClient _docFirestoreClient;

  DocRepository({@required DocFirestoreClient docFirestoreClient})
      : assert(docFirestoreClient != null),
        _docFirestoreClient = docFirestoreClient;

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
