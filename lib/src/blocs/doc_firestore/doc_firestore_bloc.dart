import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import './doc_firestore_event.dart';
import './doc_firestore_state.dart';
import '../../../src/repository/doc_repo/doc_repository.dart';

class DocFirestoreBloc extends Bloc<DocFirestoreEvent, DocFirestoreState> {
  final DocRepository _docRepository;

  DocFirestoreBloc({@required DocRepository repository})
      : assert(repository != null),
        _docRepository = repository,
        super(DocFirestoreInitial());

  @override
  Stream<DocFirestoreState> mapEventToState(DocFirestoreEvent event) async* {
    if (event is DocFirestoreSave) {
      yield DocFirestoreLoading();
      try {
        await _docRepository.addDocument(doc: event.doc);
        yield DocFirestoreSuccess();
      } catch (e) {
        print('$e');
        yield DocFirestoreFailure(error: 'add doc failed');
      }
    }
    if (event is DocFirestoreDelete) {
      yield DocFirestoreLoading();
      await _docRepository
          .deleteDocument(title: event.title)
          .then((value) async* {
        yield DocFirestoreSuccess();
      }).catchError((error) async* {
        yield DocFirestoreFailure(error: 'delete doc failed');
      });
      /*yield DocFirestoreLoading();
      try {
        await _docRepository.deleteDocument(title: event.title);
        yield DocFirestoreSuccess();
      } catch (_) {
        yield DocFirestoreFailure(error: 'delete doc failed');
      }*/
    }
    if (event is DocFirestoreDeleteAll) {
      yield DocFirestoreLoading();
      await _docRepository.deleteAll().then((value) async* {
        yield DocFirestoreSuccess();
      }).catchError((error) async* {
        yield DocFirestoreFailure(error: 'delete all docs failed');
      });
    }
    if (event is DocFirestoreFetchAll) {
      yield DocFirestoreLoading();
      await _docRepository.getAllDocuments().then((list) async* {
        yield DocFirestoreSuccess(list: list);
      }).catchError((error) async* {
        yield DocFirestoreFailure(error: 'fetch all docs failed');
      });
    }
  }
}
