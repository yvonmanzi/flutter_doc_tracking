import 'package:meta/meta.dart';

import '../../models/doc.dart';
import '../doc_repo/doc_firestore_client.dart';

class DocRepository {
  final DocFirestoreClient _docFirestoreClient;
  DocRepository({@required DocFirestoreClient docFirestoreClient})
      : assert(docFirestoreClient != null),
        _docFirestoreClient = docFirestoreClient;

  Future<void> addDocument({@required Doc doc}) async {
    return await _docFirestoreClient.addDocument(doc: doc);
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
