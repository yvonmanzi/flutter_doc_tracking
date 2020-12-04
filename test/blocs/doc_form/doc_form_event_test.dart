import 'package:doctracking/src/blocs/doc_form/doc_form.dart';
import 'package:doctracking/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// ignore: must_be_immutable
class GlobalKeyMock extends Mock implements GlobalKey<FormState> {}

void main() {
  group('DocFormEvent', () {
    final doc = Doc(
        expiration: '2030',
        notifyAtHalfYearMark: 1,
        notifyAtQuarterMark: 1,
        notifyAtOneYearMark: 1,
        title: 'example',
        notifyAtMonthMark: 1);
    final formKey = GlobalKeyMock();
    test('DocFormSaveButtonPressed has correct props', () {
      expect(DocFormSaveButtonPressed(doc: doc, formKey: formKey).props,
          [doc, formKey]);
    });
  });
}
