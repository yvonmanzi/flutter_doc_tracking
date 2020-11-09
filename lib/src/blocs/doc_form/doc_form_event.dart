import 'package:doctracking/src/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class DocEvent extends Equatable {
  const DocEvent();

  @override
  List<Object> get props => [];
}

class DocumentFormSaveButtonPressed extends DocEvent {
  final Doc doc;

  final GlobalKey<FormState> formKey;

  DocumentFormSaveButtonPressed({@required this.doc, @required this.formKey});
//TODO: all attributes should be accessed through props?
  @override
  List<Object> get props => [doc, formKey];
}
