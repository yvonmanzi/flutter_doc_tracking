import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DatePickerState extends Equatable {
  const DatePickerState();

  @override
  List<Object> get props => [];
}

class DatePickerInitial extends DatePickerState {}

class DatePickerDatePickSuccess extends DatePickerState {
  final String expirationDate;

  DatePickerDatePickSuccess({@required this.expirationDate});
}
