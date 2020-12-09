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

//TODO: This just taught me something about how i am going to deal with Validators class
class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  final String documentID;
  final Map<String, dynamic> data;

  DocumentSnapshotMock(this.documentID, this.data);
}

void main() {
  group('DocFirestoreInstance', () {
    FirestoreMock firestoreInstance;
    FirebaseUserMock firebaseUser;
    QuerySnapshotMock querySnapshot;
    CollectionReferenceMock collectionRef;
    DocumentReferenceMock documentRef;
    DocFirestoreClient docFirestoreClient;
    Doc doc;

    setUp(() {
      firestoreInstance = FirestoreMock();
      firebaseUser = FirebaseUserMock();
      querySnapshot = QuerySnapshotMock();
      collectionRef = CollectionReferenceMock();
      documentRef = DocumentReferenceMock();
      docFirestoreClient = DocFirestoreClient(
          firestoreInstance: firestoreInstance, user: firebaseUser);
      doc = Doc(
          title: 'passport_test',
          notifyAtHalfYearMark: 1,
          notifyAtMonthMark: 1,
          notifyAtOneYearMark: 1,
          notifyAtQuarterMark: 1,
          expiration: '2021');
    });
    group('should assert if at least one of the args is null', () {
      test(' should assert if user is null', () {
        expect(
          () => DocFirestoreClient(firestoreInstance: null, user: null),
          throwsA(isAssertionError),
        );
      });
      test('should assert if firestoreInstance is null', () {
        expect(
            () => DocFirestoreClient(
                firestoreInstance: firestoreInstance, user: null),
            throwsA(isAssertionError));
      });
    });

    /// Test `addDocument`
    group('addDocument', () {
      test('returns title if add doc succeeds', () async {
        final String title = 'passport_test';
        final doc = Doc(
            title: 'passport_test',
            notifyAtHalfYearMark: 1,
            notifyAtMonthMark: 1,
            notifyAtOneYearMark: 1,
            notifyAtQuarterMark: 1,
            expiration: '2021');
        final data = doc.toMap();
        when(firestoreInstance.collection('${firebaseUser.uid}'))
            .thenReturn(collectionRef);
        when(collectionRef.document('${doc.title.toLowerCase()}'))
            .thenReturn(documentRef);
        when(documentRef.setData(data))
            .thenAnswer((realInvocation) => Future.value());

        expect(await docFirestoreClient.addDocument(doc: doc), title);
      });
    });

    /// Test `deleteDocument`
    group('deleteDocument', () {
      test('returns title if deletion succeeds', () async {
        final String title = 'passport_test';

        final doc = Doc(
            title: 'passport_test',
            notifyAtHalfYearMark: 1,
            notifyAtMonthMark: 1,
            notifyAtOneYearMark: 1,
            notifyAtQuarterMark: 1,
            expiration: '2021');
        final snapshots = List<DocumentSnapshotMock>()
          ..add(DocumentSnapshotMock('1', doc.toMap()));
        when(firestoreInstance.collection('${firebaseUser.uid}'))
            .thenReturn(collectionRef);
        when(collectionRef.getDocuments())
            .thenAnswer((_) => Future.value(querySnapshot));
        when(querySnapshot.documents).thenReturn(snapshots);
        when(collectionRef.document('${doc.title}')).thenReturn(documentRef);
        when(documentRef.delete()).thenAnswer((_) => Future.value());

        expect(
            await docFirestoreClient.deleteDocument(title: title), doc.title);
      });
    });

    /// Test `getAllDocuments`
    group('getAllDocs', () {
      final doc = Doc(
          title: 'passport_test',
          notifyAtHalfYearMark: 1,
          notifyAtMonthMark: 1,
          notifyAtOneYearMark: 1,
          notifyAtQuarterMark: 1,
          expiration: '2021');

      test('it is empty when there are no documents', () async {
        when(firestoreInstance.collection('${firebaseUser.uid}'))
            .thenReturn(collectionRef);
        when(collectionRef.getDocuments())
            .thenAnswer((realInvocation) => Future.value(querySnapshot));
        final snapshots = List<DocumentSnapshotMock>();
        when(querySnapshot.documents).thenReturn(snapshots);

        expect(
            await docFirestoreClient
                .getAllDocs()
                .then((docList) => docList.isEmpty),
            true);
      });
      test('returns a list of docs when there exist some docs', () async {
        when(firestoreInstance.collection('${firebaseUser.uid}'))
            .thenReturn(collectionRef);
        when(collectionRef.getDocuments())
            .thenAnswer((realInvocation) => Future.value(querySnapshot));

        final snapshots = List<DocumentSnapshotMock>()
          ..add(DocumentSnapshotMock('1', doc.toMap()));
        snapshots.add(DocumentSnapshotMock('2', doc.toMap()));
        when(querySnapshot.documents).thenReturn(snapshots);
        expect(await docFirestoreClient.getAllDocs().then((docList) => docList),
            [doc, doc]);
      });
      /*test('return a list of docs when it succeeds', () async {
        List<Doc> documents;
        while (documents.length > 5)
          documents.add(Doc(
              title: 'passport_test',
              notifyAtHalfYearMark: 1,
              notifyAtMonthMark: 1,
              notifyAtOneYearMark: 1,
              notifyAtQuarterMark: 1,
              expiration: '2021'));

        when(docFirestoreClient.getAllDocs())
            .thenAnswer((_) async => Future.value(documents));

        expect(await docFirestoreClient.getAllDocs(), documents);*/
    });

    /// Test `deleteAll`
    group('deleteAll', () {
      test('returns nothing when deletion succeeds', () async {
        when(firestoreInstance.collection('${firebaseUser.uid}'))
            .thenReturn(collectionRef);
        when(collectionRef.getDocuments())
            .thenAnswer((realInvocation) => Future.value(querySnapshot));
        final snapshots = List<DocumentSnapshotMock>()
          ..add(DocumentSnapshotMock('1', doc.toMap()));
        snapshots.add(DocumentSnapshotMock('2', doc.toMap()));
        when(querySnapshot.documents).thenReturn(snapshots);
        when(collectionRef.document('${doc.title}')).thenReturn(documentRef);
        when(documentRef.delete()).thenAnswer((_) => Future.value([doc, doc]));

        expect(await docFirestoreClient.deleteAll(), [doc, doc]);
      });
    });
  });
}
