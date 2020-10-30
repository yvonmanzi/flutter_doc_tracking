import 'package:flutter_bloc/flutter_bloc.dart';

import './date_picker_event.dart';
import './date_picker_state.dart';

class DatePickerBloc extends Bloc<DatePickerEvent, DatePickerState> {
  static final DatePickerState _initialState = DatePickerButtonNotPressed();

  DatePickerBloc() : super(_initialState);

  @override
  Stream<DatePickerState> mapEventToState(DatePickerEvent event) async* {
    if (event is DatePickerDoneButtonPressed) {
      yield DatePickerDatePickSuccess(expirationDate: event.expirationDate);
    }
    if (event is DatePickerButtonPressed) {
      yield DatePickerInitial();
    }
  }
}
