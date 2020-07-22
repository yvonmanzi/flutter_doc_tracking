import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DocFirestoreEvent extends Equatable {
  const DocFirestoreEvent();

  @override
  List<Object> get props => [];
}

class DocFirestoreSave extends DocFirestoreEvent {
  final String title;
  final String expiryDate;

  DocFirestoreSave({@required this.title, @required this.expiryDate});

  @override
  List<Object> get props => [title, expiryDate];
}

class DocFirestoreDelete extends DocFirestoreEvent {
  final String title;

  DocFirestoreDelete({@required this.title});

  @override
  List<Object> get props => [title];
}

class DocFirestoreDeleteAll extends DocFirestoreEvent {}
