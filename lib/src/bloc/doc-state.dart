import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

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

class DocumentFormSubmissionSuccess extends DocState {}
