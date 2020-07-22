import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DocFirestoreState extends Equatable {
  const DocFirestoreState();

  @override
  List<Object> get props => [];
}

class DocFirestoreInitial extends DocFirestoreState {}

class DocFirestoreLoading extends DocFirestoreState {}

class DocFirestoreFailure extends DocFirestoreState {
  final String error;

  DocFirestoreFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class DocFirestoreSuccess extends DocFirestoreState {}
