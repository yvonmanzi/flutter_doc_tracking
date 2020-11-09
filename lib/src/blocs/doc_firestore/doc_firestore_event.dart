import 'package:doctracking/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DocFirestoreEvent extends Equatable {
  const DocFirestoreEvent();

  @override
  List<Object> get props => [];
}

class DocFirestoreSave extends DocFirestoreEvent {
  final Doc doc;

  DocFirestoreSave({@required this.doc});

  @override
  List<Object> get props => [doc];
}

// TODO: might end up using the id from firestore instead.
class DocFirestoreDelete extends DocFirestoreEvent {
  final String title;

  DocFirestoreDelete({@required this.title});

  @override
  List<Object> get props => [title];
}

class DocFirestoreFetchAll extends DocFirestoreEvent {}

class DocFirestoreDeleteAll extends DocFirestoreEvent {}
