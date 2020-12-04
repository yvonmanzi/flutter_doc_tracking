import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/src/models/models.dart';
import '../../../lib/src/repository/doc_repo/doc_firestore_client.dart';

class FirestoreMock extends Mock implements Firestore {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class QuerySnapshotMock extends Mock implements QuerySnapshot {}

class DocumentReferenceMock extends Mock implements DocumentReference {}

class MockDocFirestoreClient extends Mock implements DocFirestoreClient {
  DocFirestoreClient _real;
  FirebaseUser _user;

  MockDocFirestoreClient(FirebaseUser user, Firestore firestoreInstance) {
    _real =
        DocFirestoreClient(user: _user, firestoreInstance: firestoreInstance);
    var doc = Doc(
        title: 'passport_test',
        notifyAtHalfYearMark: 1,
        notifyAtMonthMark: 1,
        notifyAtOneYearMark: 1,
        notifyAtQuarterMark: 1,
        expiration: '2021');
    when(addDocument(doc: doc)).thenAnswer((_) => _real.addDocument(doc: doc));
  }
}

void main() {
  final firestoreInstance = FirestoreMock();
  final firebaseUser = FirebaseUserMock();
  final querySnapshot = QuerySnapshotMock();
  final collectionRef = CollectionReferenceMock();
  group('should assert if at least one of the args is null', () {
    test(' should assert if user is null', () {
      expect(
        () => DocFirestoreClient(firestoreInstance: null, user: null),
        throwsA(isAssertionError),
      );
      test('should assert if firestoreInstance is null', () {
        expect(
            () => DocFirestoreClient(
                firestoreInstance: firestoreInstance, user: null),
            throwsA(isAssertionError));
      });
    });
  });

  group('addDocument', () async {
    final mockFirestoreInstance = FirestoreMock();
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

  group('deleteDocument', () async {
    final mockFirestoreInstance = FirestoreMock();
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

  group('fetchAllDocuments', () async {
    //TODO: would thenAsnwer work too?
    when(firestoreInstance.collection('path')).thenReturn(collectionRef);
    expect(await collectionRef.getDocuments().isEmpty(), true);

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
