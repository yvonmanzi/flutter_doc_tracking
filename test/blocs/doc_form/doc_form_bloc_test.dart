import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/doc_firestore/doc_firestore.dart';
import 'package:doctracking/src/blocs/doc_form/doc_form.dart';
import 'package:doctracking/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class DocFirestoreBlocMock extends MockBloc implements DocFirestoreBloc {}

// ignore: must_be_immutable
class GlobalKeyMock extends Mock implements GlobalKey<FormState> {}

void main() {
  final docFirestoreBloc = DocFirestoreBlocMock();
  final bloc = DocFormBloc(docFirestoreBloc: docFirestoreBloc);
  tearDown(() {
    docFirestoreBloc?.close();
    bloc?.close();
  });
  test('initial state is correct', () {
    expect(bloc.state, DocumentFormInitial());
  });
  test(
      'throws assertion error when docFirestoreBloc dependency is null', () {});
  group('DocFormBloc', () {
    final formKey = GlobalKeyMock();
    final doc = Doc(
        expiration: '2030',
        notifyAtHalfYearMark: 1,
        notifyAtQuarterMark: 1,
        notifyAtOneYearMark: 1,
        title: 'example',
        notifyAtMonthMark: 1);
    /*
   * test if bloc emits nothing when no event is added
   * */
    blocTest('emits [] when nothing is added', build: () {
      return Future.value(bloc);
    }, expect: []);
    /*
    * test when saving a doc succeeds
    * */
    blocTest(
        'streams correct states when DocFormSaveButtonPressed is added and form validation succeeds',
        build: () {
      final form = formKey.currentState;
      when(form.validate()).thenReturn(true);
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFormSaveButtonPressed(doc: doc, formKey: formKey));
    }, expect: [
      DocumentFormSubmissionLoading(),
      DocumentFormSubmissionSuccess(doc: doc),
    ]);
    /*
    * test when form validation fails
    * */
    blocTest(
        'streams correct states when DocFormSaveButtonPressed is added and form validation fails',
        build: () {
      final form = formKey.currentState;
      when(form.validate()).thenReturn(false);
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DocFormSaveButtonPressed(doc: doc, formKey: formKey));
    }, expect: [
      DocumentFormSubmissionLoading(),
      DocumentFormSubmissionFailure(error: 'form is invalid'),
    ]);
  });
}
