import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../lib/src/models/models.dart';
import '../../../lib/src/repository/doc_repo/doc_firestore_client.dart';

class MockFirestore extends Mock implements Firestore {}
class MockFirebaseUser extends Mock implements FirebaseUser{}

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
  group('should assert if at least one of the args is null', () {
    final mockFirestoreInstance = MockFirestore();
    final mockFirebaseUser = MockFirebaseUser();

    test(' should assert if user is null', (){
      expect(
            () => DocFirestoreClient(firestoreInstance: mockFirestoreInstance, user: null),
        throwsA(isAssertionError),);
      test('should assert if firestoreInstance is null', (){
        expect(()=> DocFirestoreClient(firestoreInstance: null, user: mockFirebaseUser.currentUser() ), matcher)
      });
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