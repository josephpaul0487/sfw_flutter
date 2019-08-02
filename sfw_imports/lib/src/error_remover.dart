import 'package:flutter/material.dart' show StatefulWidget,State;
import 'package:sfw_imports/src/ui.dart';

abstract class SfwState <T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    try {
      if(mounted)
        super.setState(fn);
    } catch(e) {
      print(e);
    }
  }

  bool toastMessage(bool showToast,String toastMessage) {
    if(showToast && (toastMessage!=null && toastMessage.isNotEmpty))
      UiHelper.showToast(toastMessage);
    return showToast;
  }

  bool isEmpty(String str,{String toastMessage}) {
    return this.toastMessage(str==null || str.trim().isEmpty ,toastMessage);
  }


}