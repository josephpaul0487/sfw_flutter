import 'dart:core';

class Validator {
  static const int passwordMin=6;
  static const int passwordMax=32;
  static final  RegExp passwordPattern=RegExp('(((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#&%]).{'+'$passwordMin,$passwordMax}))');
  static final  RegExp numberPattern=RegExp(r'\d');
  static final  RegExp namePattern=RegExp(r"[a-zA-Z0-9 ]*");
  static final  RegExp specialCharactersPattern=RegExp(r"[$=\\\\|<>^*%]");
  static final RegExp emailPattern=RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');



  static bool isValidPassword(String password) {
    return true;
    //return password?.contains(passwordPattern, 0);
  }

  static bool isNameValid(String name) {
    return name!=null && namePattern.hasMatch(name);
  }

  static bool isEmailValid(String email) {
    return emailPattern.hasMatch(email);
  }

}