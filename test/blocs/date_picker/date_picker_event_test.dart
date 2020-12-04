import 'package:doctracking/src/blocs/date_picker/date_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatePicker events', () {
    test('DatePickerButtonPressed has correct props', () {
      expect(DatePickerButtonPressed().props, []);
    });
    test('DatePickerDoneButtonPressed has correct props', () {
      final String expiration = '2020';
      expect(DatePickerDoneButtonPressed(expirationDate: expiration).props,
          [expiration]);
    });
  });
}
