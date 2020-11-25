import 'package:doctracking/src/models/doc.dart';
import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DocFirestoreClientMock extends Mock implements DocFirestoreClient {}

void main() {
  final DocFirestoreClientMock docFirestoreClient = DocFirestoreClientMock();
  final DocRepository docRepository =
      DocRepository(docFirestoreClient: docFirestoreClient);
  final Doc doc = Doc(
      title: 'example-title',
      expiration: '2030',
      notifyAtOneYearMark: 1,
      notifyAtHalfYearMark: 1,
      notifyAtQuarterMark: 1,
      notifyAtMonthMark: 1);

  test('should assert if null', () {
    expect(
      () => DocRepository(docFirestoreClient: null),
      throwsA(isAssertionError),
    );
  });
  //TODO: think about how the addDoc is working here.
  group('addDocument', () async {
    when(docFirestoreClient.addDocument(doc: doc))
        .thenAnswer((_) => Future.value());
    test('calling addDocument returns void', () async {
      expect(await docRepository.addDocument(doc: doc));
      verify(docRepository.addDocument(doc: doc)).called(1);
    });
  });
}
