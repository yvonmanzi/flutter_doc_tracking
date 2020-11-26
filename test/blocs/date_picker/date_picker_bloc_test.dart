import 'package:bloc_test/bloc_test.dart';
import 'package:doctracking/src/blocs/date_picker/date_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DatePickerBloc bloc;
  setUp(() {
    bloc = DatePickerBloc();
  });
  tearDown(() {
    bloc?.close();
  });
  test('initial state is correct', () {
    expect(bloc.state, DatePickerButtonNotPressed());
  });
  group('DatePickerBloc', () {
    final String expirationDateString = '2020';
    blocTest('streams the right states when DatePickerButtonPressed is added',
        build: () {
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(DatePickerButtonPressed());
    }, expect: [DatePickerInitial()]);
    blocTest('streams the right states when DatePickerDoneButtonPressed',
        build: () {
      return Future.value(bloc);
    }, act: (bloc) {
      return bloc.add(
          DatePickerDoneButtonPressed(expirationDate: expirationDateString));
    }, expect: [
      DatePickerDatePickSuccess(expirationDate: expirationDateString),
    ]);
  });
}
