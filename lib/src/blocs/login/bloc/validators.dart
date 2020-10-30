class Validators {
  static final RegExp _emailRegExp = RegExp(r'');
  static final RegExp _passwordRegExp = RegExp(r'');
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
