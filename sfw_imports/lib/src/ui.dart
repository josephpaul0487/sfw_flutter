
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_helper.dart';

class UiHelper {
  static void showToast(
      String msg,
      ) {
    try {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: SfwHelper.setSp(30.0));
    } catch(e){}

  }
}