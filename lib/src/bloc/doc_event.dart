import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DocEvent extends Equatable {
  const DocEvent();

  @override
  List<Object> get props => [];
}

class DocumentFormSaveButtonPressed extends DocEvent {
  final String title;
  final String expiration;

  DocumentFormSaveButtonPressed(
      {@required this.title, @required this.expiration});

  @override
  List<Object> get props => [title, expiration];
}

class DocumentFormPickDateButtonPressed extends DocEvent {}
