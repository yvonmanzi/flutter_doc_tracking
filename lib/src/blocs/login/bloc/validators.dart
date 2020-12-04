class Validators {
  final RegExp _emailRegExp =
      RegExp(r'^([a-z])([a-z0-9]+)(@)([a-z]+)(\.)([a-z]+)$');
  final RegExp _passwordRegExp = RegExp(r'(.){5,}');
  isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  // non-static members for mocking
  bool getIsValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool getIsValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
