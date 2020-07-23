import 'package:doctracking/src/bloc/bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_bloc.dart';
import 'package:doctracking/src/bloc/doc_firestore_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class DocFormBloc extends Bloc<DocEvent, DocState> {
  final DocFirestoreBloc _docFirestoreBloc;
  static final DocState _initialState = DocumentFormInitial();

  DocFormBloc(
      {@required DocState initialState,
      @required DocFirestoreBloc docFirestoreBloc})
      : assert(docFirestoreBloc != null),
        _docFirestoreBloc = docFirestoreBloc,
        super(_initialState);

  @override
  Stream<DocState> mapEventToState(DocEvent event) async* {
    if (event is DocumentFormSaveButtonPressed) {
      yield DocumentFormSubmissionLoading();
      final FormState form = event.formKey.currentState;
      if (form.validate()) {
        yield DocumentFormSubmissionSuccess(event.title, event.expiration);
        _docFirestoreBloc.add(
            DocFirestoreSave(title: event.title, expiryDate: event.expiration));
      } else
        DocumentFormSubmissionFailure(error: 'form is invalid');
    }
  }
}
