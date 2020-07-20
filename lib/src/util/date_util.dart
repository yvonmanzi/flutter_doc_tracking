import 'package:intl/intl.dart';

class Validate {
  // Validations
  static String validateTitle(String title) {
    return (title != null && title != "") ? null : "title cannot be empty";
  }

  //TODO: Get the remaining days before doc expires. the naming isn't good enough
  static String getExpiryString(String expiration) {
    var time = DateUtils.convertStringToDate(expiration);
    var currentTime = DateTime.now();
    Duration diff = time.difference(currentTime);
    int dd = diff.inDays + 1;
    return (dd > 0) ? dd.toString() : "0";
  }

  static bool stringToBool(String str) {
    return (int.parse(str) > 0) ? true : false;
  }

  static bool intToBool(int val) {
    return (val > 0) ? true : false;
  }

  static String boolToString(bool val) {
    return (val == true) ? "1" : "0";
  }

  static int boolToInt(bool val) {
    return (val == true) ? 1 : 0;
  }
}

class DateUtils {
  static DateTime convertStringToDate(String inputString) {
    try {
      var d = DateFormat('yyyy-MM-dd').parseStrict(inputString);
      return d;
    } catch (_) {
      return null;
    }
  }

//TODO: think about bettr naming of this function. And add comments explaining what this does.
  static String convertToDateFull(String input) {
    try {
      var date = DateFormat(input).parseStrict(input);
      var formatter = DateFormat('dd MMM yyyy');
      return formatter.format(date);
    } catch (_) {
      return null;
    }
  }

  //TODO: better naming. also add comments. (didn't know that dart doesn't have overloading
  static String convertToDateFullDt(DateTime input) {
    try {
      var formatter = DateFormat('dd MMM yyyy');
      return formatter.format(input);
    } catch (_) {
      return null;
    }
  }

  static bool isDate(String date) {
    try {
      DateFormat('yyyy-MM-dd').parseStrict(date);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isValidDate(String date) {
    if (date.isEmpty || !date.contains("-") || date.length < 10) return false;
    List<String> dateParts = date.split("-");
    var d = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]),
        int.parse(dateParts[2]));
    return d != null && isDate(date) && d.isAfter(DateTime.now());
  }

  static String daysAheadAsStr(int daysAhead) {
    var now = DateTime.now();
    DateTime ft = now.add(Duration(days: daysAhead));
    return ftDateAsStr(ft);
  }

  static String ftDateAsStr(DateTime ft) {
    return ft.year.toString() +
        "-" +
        ft.month.toString().padLeft(2, "0") +
        "-" +
        ft.day.toString().padLeft(2, "0");
  }

  static String trimDate(String date) {
    if (date.contains(" ")) {
      List<String> p = date.split(" ");
      return p[0];
    } else
      return date;
  }
}
