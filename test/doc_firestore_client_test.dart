import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctracking/src/models/models.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirestore extends Mock implements Firestore {}

class MockDocFirestoreClient extends Mock implements DocFirestoreClient {
  DocFirestoreClient _real;

  MockDocFirestoreClient(Firestore firestoreInstance) {
    _real = DocFirestoreClient(firestoreInstance: firestoreInstance);
    when(addDocument(title: 'passport_test', expiration: '2021')).thenAnswer(
        (_) => _real.addDocument(title: 'passport', expiration: '2021'));
  }
}

void main() {
  test('should assert if null', () {
    expect(
      () => DocFirestoreClient(firestoreInstance: null),
      throwsA(isAssertionError),
    );
  });

  group('addDocument', () {
    final mockFirestoreInstance = MockFirestore();
    final mockDocFirestoreClient =
        MockDocFirestoreClient(mockFirestoreInstance);
    test('return nothing if no error was returned', () async {
      final String title = 'passport_test';
      final String expiration = '2021';
      final mockDoc = Doc(title: title, expiration: expiration);

      when(mockDocFirestoreClient.addDocument(
              title: title, expiration: expiration))
          .thenAnswer((_) async => Future.value(title));

      expect(
          await mockDocFirestoreClient.addDocument(
              title: 'passport_test', expiration: '2021'),
          title);
    });
  });

  group('deleteDocument', () {
    final mockFirestoreInstance = MockFirestore();
    final mockDocFirestoreClient =
        MockDocFirestoreClient(mockFirestoreInstance);
    test('return title if deletion succeeds', () async {
      final String title = 'passport_test';
      when(mockDocFirestoreClient.deleteDocument(title: title))
          .thenAnswer((_) async => Future.value(title));

      expect(
          await mockDocFirestoreClient.deleteDocument(title: 'passport_test'),
          title);
    });
  });

  group('fetchAllDocuments', () {
    final mockFirestoreInstance = MockFirestore();
    final mockDocFirestoreClient =
        MockDocFirestoreClient(mockFirestoreInstance);
    test('return a list of docs when it succeeds', () async {
      List<Doc> documents;
      while (documents.length > 5)
        documents.add(Doc(title: 'passport_test', expiration: '2021'));

      when(mockDocFirestoreClient.getAllDocs())
          .thenAnswer((_) async => Future.value(documents));

      expect(await mockDocFirestoreClient.getAllDocs(), documents);
    });
  });
}
//TODO: WRITE MORE TESTS
