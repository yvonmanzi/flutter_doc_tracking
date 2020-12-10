import 'package:doctracking/src/models/doc.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DocFirestoreClientMock extends Mock implements DocFirestoreClient {}

void main() {
  group('DocRepository', () {
    Doc doc;
    DocRepository docRepository;
    DocFirestoreClientMock docFirestoreClient;
    setUp(() {
      doc = Doc(
          title: 'example-title',
          expiration: '2030',
          notifyAtOneYearMark: 1,
          notifyAtHalfYearMark: 1,
          notifyAtQuarterMark: 1,
          notifyAtMonthMark: 1);
      docFirestoreClient = DocFirestoreClientMock();
      docRepository = DocRepository(docFirestoreClient: docFirestoreClient);
    });
    test('asserts null if `docFirestoreClient` is null', () {
      expect(
        () => DocRepository(docFirestoreClient: null),
        throwsA(isAssertionError),
      );
    });

    /// Test `addDocument`
    group('addDocument', () {
      test('returns title of the added document', () async {
        when(docFirestoreClient.addDocument(doc: doc))
            .thenAnswer((_) => Future.value(doc.title));
        expect(await docRepository.addDocument(doc: doc), doc.title);
        verify(docRepository.addDocument(doc: doc)).called(1);
      });
    });

    /// Test `deleteDocument`
    group('deleteDocument', () {
      test('returns the title of the deleted document', () async {
        when(docFirestoreClient.deleteDocument(title: doc.title))
            .thenAnswer((realInvocation) => Future.value(doc.title));
        expect(await docRepository.deleteDocument(title: doc.title), doc.title);
      });
    });

    /// Test `getAllDocuments`
    group('getAllDocuments', () {
      test('returns all documents', () async {
        when(docFirestoreClient.getAllDocs()).thenAnswer(
            (realInvocation) => Future.value(List<Doc>()..add(doc)));
        expect(await docRepository.getAllDocuments(), [doc]);
      });
    });

    /// Test `deleteAll`
    group('getAllDocuments', () {
      test('returns all documents deleted from the db', () async {
        when(docFirestoreClient.deleteAll()).thenAnswer(
            (realInvocation) => Future.value(List<Doc>()..add(doc)));
        expect(await docRepository.deleteAll(), [doc]);
      });
    });
  });
}
