import 'package:doctracking/src/blocs/doc_firestore/doc_firestore.dart';
import 'package:doctracking/src/models/doc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocFirestoreEvent', () {
    final Doc doc = Doc(
        expiration: '2030',
        notifyAtHalfYearMark: 1,
        notifyAtQuarterMark: 1,
        notifyAtOneYearMark: 1,
        title: 'example',
        notifyAtMonthMark: 1);
    test('DocFirestoreSave has correct props ', () {
      expect(DocFirestoreSave(doc: doc), [doc]);
    });
    test('DocFirestoreDelete', () {
      expect(DocFirestoreDelete(title: doc.title), [doc.title]);
    });
    test('DocFirestoreFetchAll', () {
      expect(DocFirestoreFetchAll(), []);
    });
    test('DocFirestoreDeleteAll', () {
      expect(DocFirestoreDeleteAll(), []);
    });
  });
}
