import 'package:meta/meta.dart';

import '../../models/doc.dart';
import '../doc_repo/doc_firestore_client.dart';

/// Build a clean API to interact with our underlying firestore database
class DocRepository {
  final DocFirestoreClient _docFirestoreClient;

  /// Injecting dependencies through constructors to allow smooth testing
  DocRepository({@required DocFirestoreClient docFirestoreClient})
      : assert(docFirestoreClient != null),
        _docFirestoreClient = docFirestoreClient;

  /// Add a document to the cloud firestore
  ///
  /// Arguments
  ///
  /// * `doc` - the document to be added to the cloud firestore db
  ///
  /// Returns
  ///
  /// * `Future<String>` - the title of the added document
  Future<String> addDocument({@required Doc doc}) async {
    return await _docFirestoreClient.addDocument(doc: doc);
  }

  /// Delete a document from the cloud firestore
  ///
  /// Arguments
  ///
  /// * `title` - a title of the document to be deleted
  ///
  /// Returns
  ///
  /// * `Future<String>` - a title of the deleted document
  Future<String> deleteDocument({@required String title}) async {
    return await _docFirestoreClient.deleteDocument(title: title);
  }

  /// Get all documents currently stored in our firestore db
  ///
  /// Returns
  ///
  /// * `Future<List<Doc>>` - a future of all documents in the db
  Future<List<Doc>> getAllDocuments() async {
    return await _docFirestoreClient.getAllDocs();
  }

  /// Delete all docs currently stored in our firestore db
  ///
  /// Returns
  ///
  /// * `Future<List<Doc>>` - a future of document list that was deleted
  Future<List<Doc>> deleteAll() async {
    return await _docFirestoreClient.deleteAll();
  }
}
