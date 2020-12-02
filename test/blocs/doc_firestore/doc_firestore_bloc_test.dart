import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/doc_firestore/doc_firestore.dart';
import 'package:doctracking/src/models/doc.dart';
import 'package:doctracking/src/repository/doc_repo/doc_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DocRepositoryMock extends Mock implements DocRepository {}

void main() {
  DocFirestoreBloc bloc;
  DocRepositoryMock repository = DocRepositoryMock();
  setUp(() {
    bloc = DocFirestoreBloc(repository: repository);
  });
  tearDown(() {
    bloc?.close();
  });
  test('should assert if repository is null', () {
    expect(DocFirestoreBloc(repository: null), throwsA(AssertionError));
  });
  group('DocFirestoreBloc', () {
    final Doc doc = Doc(
        expiration: '2030',
        notifyAtHalfYearMark: 1,
        notifyAtQuarterMark: 1,
        notifyAtOneYearMark: 1,
        title: 'example',
        notifyAtMonthMark: 1);
    blocTest(
        'streams correct states when DocFirestoreSave is added and succeeds',
        build: () {
      when(repository.addDocument(doc: doc))
          .thenAnswer((realInvocation) => Future.value());
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreSave(doc: doc));
    }, expect: [DocFirestoreLoading(), DocFirestoreSuccess()]);
    blocTest('streams correct states when DocFirestoreSave is added but fails',
        build: () {
      when(repository.addDocument(doc: null))
          .thenThrow((_) async => throw 'add doc failed');
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreSave(doc: null));
    }, expect: [
      DocFirestoreLoading(),
      DocFirestoreFailure(error: 'add doc failed')
    ]);
    blocTest(
        'streams correct states when DocFirestoreDelete is added and succeeds',
        build: () {
      when(repository.deleteDocument(title: doc.title))
          .thenAnswer((realInvocation) => Future.value());
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDelete(title: doc.title));
    }, expect: [DocFirestoreLoading()]);
    blocTest(
        'streams correct states when DocFirestoreDelete is added and fails',
        build: () {
      when(repository.deleteDocument(title: null))
          .thenThrow((_) async => throw "delete doc failed");
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDelete(title: doc.title));
    }, expect: [
      DocFirestoreLoading(),
      DocFirestoreFailure(error: 'delete doc failed')
    ]);
    blocTest(
        'streams correct states when DocFirestoreDeleteAll is added and succeeds',
        build: () {
      when(repository.deleteAll())
          .thenAnswer((realInvocation) => Future.value());
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDeleteAll());
    }, expect: [DocFirestoreLoading(), DocFirestoreSuccess()]);
    blocTest(
        'streams correct states when DocFirestoreDeleteAll is added and fails',
        build: () {
      when(repository.deleteAll())
          .thenThrow(() async => throw 'delete all docs failed');
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDeleteAll());
    }, expect: [
      DocFirestoreLoading(),
      DocFirestoreFailure(error: 'delete all docs failed'),
    ]);
    blocTest(
        'streams correct states when DocFirestoreFetchAll is added and succeeds',
        build: () {
      when(repository.getAllDocuments())
          .thenAnswer((realInvocation) => Future.value());
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDeleteAll());
    }, expect: [DocFirestoreLoading(), DocFirestoreSuccess()]);
    blocTest(
        'streams correct states when DocFirestoreFetchAll is added and fails',
        build: () {
      when(repository.getAllDocuments())
          .thenThrow(() async => throw 'fetch all docs failed');

      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFirestoreDeleteAll());
    }, expect: [
      DocFirestoreLoading(),
      DocFirestoreFailure(error: 'fetch all docs failed')
    ]);
  });
}
