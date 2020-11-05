class Validators {
  static final RegExp _emailRegExp =
      RegExp(r'^([a-z])([a-z0-9]+)(@)([a-z]+)(\.)([a-z]+)$');
  static final RegExp _passwordRegExp = RegExp(r'(.){5,}');
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
