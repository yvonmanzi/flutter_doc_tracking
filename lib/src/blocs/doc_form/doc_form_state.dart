import 'package:doctracking/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DocState extends Equatable {
  const DocState();

  @override
  List<Object> get props => [];
}

class DocumentFormInitial extends DocState {}

class DocumentFormSubmissionLoading extends DocState {}

class DocumentFormSubmissionFailure extends DocState {
  final String error;

  DocumentFormSubmissionFailure({@required this.error});

  @override
  List<Object> get props => [];
}

class DocumentFormSubmissionSuccess extends DocState {
  final Doc doc;

  DocumentFormSubmissionSuccess({@required this.doc});

  @override
  List<Object> get props => [doc];

  @override
  String toString() {
    return 'this is ${doc.title} expiring on ${doc.expiration}';
  }
}
