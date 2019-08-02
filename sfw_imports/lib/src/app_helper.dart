import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SfwHelper {
  static ScreenUtil util;
  static double screenWidth;
  static double screenWidthPx;
  static double screenHeight;
  static double screenHeightPx;

  static initialize(BuildContext context) {
    if (util == null) {
      util = ScreenUtil();
      util.init(context);
      screenHeight = ScreenUtil.screenHeightDp;
      screenHeightPx = ScreenUtil.screenHeight;
      screenWidth = ScreenUtil.screenWidthDp;
      screenWidthPx = ScreenUtil.screenWidth;
    }
  }

  static setWidth(double width) => util.setWidth(width);

  static setHeight(double height) => util.setHeight(height);

  static setSp(double fontSize) => util.setSp(fontSize);

  static double pxToDp(double px) {
    return setWidth(px);
  }

  static String numberToString(int number,
      {int minLength = 2, bool isForPrefix = true, String deliminator = "0"}) {
    if (number == null || minLength == null || isForPrefix == null) {
      return number == null ? "" : "$number";
    }
    String num = "$number";
    if (num.length == minLength) {
      return "$number";
    }
    for (int i = num.length; i < minLength; ++i) {
      if (isForPrefix)
        num = deliminator + num;
      else
        num += deliminator;
    }
    return num;
  }

  static String convertDate(String fromFormat,String toFormat,String date) {
    try {
      return DateFormat(toFormat).format( DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertWebToLocalDate(String toFormat,String date,{String fromFormat="yyyy-MM-dd HH:mm:ss"}) {
    try {
      return DateFormat(toFormat).format( DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertUtfToLocalDate(String fromFormat,String toFormat,String date) {
    try {
      return DateFormat(toFormat).format( DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertLocalToUtfDate(String fromFormat,String toFormat,String date) {
    try {
      return DateFormat(toFormat).format( DateFormat(fromFormat).parse(date));
    } catch(e)  {
      print(e);
      return "";
    }
  }

  static String convertLocalToWebDate(String fromFormat,String date,{String toFormat="yyyy-MM-dd HH:mm:ss"}) {
    return convertLocalToUtfDate(fromFormat,toFormat,date);
  }

  static bool isDateAfter(String format,String date,String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAfter( DateFormat(format).parse(dateToCompare));
    } catch(e) {
      return false;
    }
  }

  static bool isDateBefore(String format,String date,String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isBefore( DateFormat(format).parse(dateToCompare));
    } catch(e) {
      return false;
    }
  }

  static bool isEqual(String format,String date,String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAtSameMomentAs( DateFormat(format).parse(dateToCompare));
    } catch(e) {
      return false;
    }
  }

  static bool isDateAfterDateTime(String format,String date,DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAfter( dateToCompare);
    } catch(e) {
      return false;
    }
  }

  static bool isDateBeforeDateTime(String format,String date,DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isBefore( dateToCompare);
    } catch(e) {
      return false;
    }
  }

  static bool isEqualDateTime(String format,String date,DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAtSameMomentAs( dateToCompare);
    } catch(e) {
      return false;
    }
  }

  static DateTime parse(String format,String date,{DateTime defDateTime,bool isUtc=false}) {
    try {
      return DateFormat(format).parse(date);
    } catch(e) {
      return defDateTime ?? null;
    }
  }




  static void hideKeyboard(BuildContext ctx) {
    try {
      FocusScope.of(ctx).requestFocus(FocusNode());
     // SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch(e) {}

  }

  static String extension(String fileUrl) {
    return fileUrl==null || !fileUrl.contains(".")?"":fileUrl.substring(fileUrl.indexOf(".")+1);;
  }

  static bool isDocument(fileUrl) {
    String ext=extension(fileUrl).toLowerCase();
    return ext!="" && (ext=='pdf' || ext=='doc' || ext=='txt' || ext=='docx' || ext=='ppt' || ext=='pptx' || ext=='xls' || ext=='xlsx');
  }

  static bool isImage(fileUrl) {
    String ext=extension(fileUrl).toLowerCase();
    return ext!="" && (ext=='jpg' || ext=='jpeg' || ext=='png');
  }


}
