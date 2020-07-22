import 'package:doctracking/src/bloc/doc_firestore_event.dart';
import 'package:doctracking/src/bloc/doc_firestore_state.dart';
import 'package:doctracking/src/repository/doc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

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
  }
}
