import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

abstract class DocEvent extends Equatable {
  const DocEvent();

  @override
  List<Object> get props => [];
}

class DocumentFormSaveButtonPressed extends DocEvent {
  final String title;
  final String expiration;
  final GlobalKey<FormState> formKey;

  DocumentFormSaveButtonPressed(
      {@required this.title,
      @required this.expiration,
      @required this.formKey});

  @override
  List<Object> get props => [title, expiration, formKey];
}
