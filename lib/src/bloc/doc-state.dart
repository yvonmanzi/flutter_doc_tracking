import 'package:equatable/equatable.dart';

abstract class DocState extends Equatable {
  const DocState();

  @override
  List<Object> get props => [];
}

class DocumentFormInitial extends DocState {}

class DocumentFormSubmissionLoading extends DocState {}

class DocumentFormSubmissionFailure extends DocState {}

class DocumentFormSubmissionSuccess extends DocState {}
