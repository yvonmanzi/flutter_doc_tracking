import 'package:doctracking/src/repository/doc_repo/doc_firestore_client.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDocFirestoreClient extends Mock implements DocFirestoreClient {}

void main() {
  test('should assert if null', () {
    expect(
      () => DocRepository(docFirestoreClient: null),
      throwsA(isAssertionError),
    );
  });
  //TODO: think about how the addDoc is working here.
  group('addDocument', () async {
    final mockDocRepository =
        DocRepository(docFirestoreClient: MockDocFirestoreClient());
    test('should call addDocument from DocFirestoreClient ', () async {
      when(mockDocRepository.addDocument(doc: null))
          .thenAnswer((_) async => Future.value());

      mockDocRepository.addDocument(doc: null);
      verify(mockDocRepository.addDocument(doc: null)).called(1);
    });
  });
}
