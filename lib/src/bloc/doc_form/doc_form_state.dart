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
  final String title;
  final String expiryDate;

  DocumentFormSubmissionSuccess(this.title, this.expiryDate);

  @override
  List<Object> get props => [title, expiryDate];

  @override
  String toString() {
    return 'this is $title expiring on $expiryDate';
  }
}
