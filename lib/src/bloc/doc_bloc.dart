import 'package:doctracking/src/bloc/bloc.dart';
import 'package:doctracking/src/repository/doc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocFormBloc extends Bloc<DocEvent, DocState> {
  final DocRepository _docRepository;
  static final DocState _initialState = DocumentFormInitial();

  DocFormBloc(DocRepository docRepository, DocState initialState)
      : assert(docRepository != null),
        _docRepository = docRepository,
        super(_initialState);

  @override
  Stream<DocState> mapEventToState(DocEvent event) async* {
    if (event is DocumentFormSaveButtonPressed) {
      yield DocumentFormSubmissionLoading();
      try {
//TODO: first convert our inputs to the right formats. i.e: convert expiration to date instead of string
        await _docRepository.addDocument(
            title: event.title, expiration: event.expiration);
        yield DocumentFormSubmissionSuccess();
      } catch (_) {
        yield DocumentFormSubmissionFailure();
      }
    }
    if (event is DocumentFormPickDateButtonPressed) {
      yield DocumentFormPickingDate();
    }
  }
}
