import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DatePickerEvent extends Equatable {
  const DatePickerEvent();

  @override
  List<Object> get props => [];
}

class DatePickerButtonPressed extends DatePickerEvent {}

class DatePickerDoneButtonPressed extends DatePickerEvent {
  final String expirationDate;
  DatePickerDoneButtonPressed({@required this.expirationDate});

  @override
  List<Object> get props => [expirationDate];
}
