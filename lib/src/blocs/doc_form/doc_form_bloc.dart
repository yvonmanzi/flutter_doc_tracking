import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../src/blocs/doc_firestore/doc_firestore.dart';
import 'doc_form.dart';

/*
* Here you may ask, wait but why are we injecting dependencies this way?
Why not just initialize them statically here in the classes? Well, the
 Answer is that injecting dependencies top-down helps us in testing. they
 Can have different values when we are testing. but if they were to be initialized
Here, they would always have just one value that's assigned. no way to vary values to allow
 testing.
* */
class DocFormBloc extends Bloc<DocEvent, DocState> {
  final DocFirestoreBloc _docFirestoreBloc;

  DocFormBloc({@required DocFirestoreBloc docFirestoreBloc})
      : assert(docFirestoreBloc != null),
        _docFirestoreBloc = docFirestoreBloc,
        super(DocumentFormInitial());

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
