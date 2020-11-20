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
  final Doc _doc;

  final GlobalKey<FormState> _formKey;

  DocumentFormSaveButtonPressed(
      {@required Doc doc, @required GlobalKey<FormState> formKey})
      : assert(doc != null),
        assert(formKey != null),
        _doc = doc,
        _formKey = formKey;
  @override
  List<Object> get props => [_doc, _formKey];
}
