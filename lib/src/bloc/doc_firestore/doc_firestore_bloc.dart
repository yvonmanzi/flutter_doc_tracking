import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import './doc_firestore_event.dart';
import './doc_firestore_state.dart';
import '../../../src/repository/doc_repo/doc_repository.dart';

class DocFirestoreBloc extends Bloc<DocFirestoreEvent, DocFirestoreState> {
  final DocRepository _repository;
  static final DocFirestoreState _initialState = DocFirestoreInitial();

  DocFirestoreBloc({@required DocRepository repository})
      : assert(repository != null),
        _repository = repository,
        super(_initialState);

  @override
  Stream<DocFirestoreState> mapEventToState(DocFirestoreEvent event) async* {
    if (event is DocFirestoreSave) {
      try {
        _repository.addDocument(
            title: event.title, expiration: event.expiryDate);
        yield DocFirestoreSuccess();
      } catch (error) {
        yield DocFirestoreFailure(error: error);
      }
    }
    if (event is DocFirestoreDelete) {
      try {
        _repository.deleteDocument(title: event.title);
        yield DocFirestoreSuccess();
      } catch (error) {
        yield DocFirestoreFailure(error: error);
      }
    }
    if (event is DocFirestoreDeleteAll) {
      try {
        _repository.deleteAll();
        yield DocFirestoreSuccess();
      } catch (error) {
        yield DocFirestoreFailure(error: error);
      }
    }
    if (event is DocFirestoreFetchAll) {
      try {
        yield DocFirestoreLoading();
        final list = await _repository.getAllDocuments();
        yield DocFirestoreSuccess(list: list);
      } catch (error) {
        yield DocFirestoreFailure(error: error.toString());
      }
    }
  }
}
