import 'package:meta/meta.dart';

import '../../models/doc.dart';
import '../doc_repo/doc_firestore_client.dart';

/*
* Build a clean API to interact with our underlying firestore database
* */
class DocRepository {
  final DocFirestoreClient _docFirestoreClient;
  /*
  * Injecting dependencies through constructors to allow smooth testing
  * */
  DocRepository({@required DocFirestoreClient docFirestoreClient})
      : assert(docFirestoreClient != null),
        _docFirestoreClient = docFirestoreClient;
  // Add a document to cloud firestore
  //TODO: this is a prob. it shouldn't return a void. we woulldn't be able to test it.
  // turns out you could use an async method in thenAnswer.
  Future<void> addDocument({@required Doc doc}) async {
    return await _docFirestoreClient.addDocument(doc: doc);
  }

// Delete a document from cloud firestore
  Future<void> deleteDocument({@required String title}) async {
    await _docFirestoreClient.deleteDocument(title: title);
  }

// Get all documents currently stored in our firestore db
  Future<List<Doc>> getAllDocuments() async {
    return await _docFirestoreClient.getAllDocs();
  }

// Delete all docs currently stored in our firestore db
  Future<void> deleteAll() async {
    await _docFirestoreClient.deleteAll();
  }
}
