

class AppStyles {}

class AppTextStyles {
  static TextStyle create(
      {double fontSize,
        Color textColor,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        String fontFamily,
        double lineSpace=1,}) {
    return TextStyle(
      height: lineSpace==null?1:lineSpace,
      color: textColor == null ? SfwColors.txtCommon:textColor,
      fontSize: fontSize ==null ? SfwHelper.setSp(SfwConstants.tsTxtCommon) :fontSize,
      fontWeight: fontWeight == null ? FontWeight.normal: fontWeight,
      fontStyle: fontStyle ==null ? FontStyle.normal: fontStyle,
      fontFamily: fontFamily,
    );
  }

  static TextStyle normal({Color textColor=SfwColors.txtCommon,double textSize,double lineSpace}) {
    return create(textColor: textColor,fontSize: textSize,lineSpace: lineSpace);
  }

  static TextStyle bold(
      {double fontSize, Color textColor=SfwColors.txtBoldCommon, FontWeight fontWeight,String fontFamily,double lineSpace}) {
    return create(
        fontSize: fontSize ==null ? SfwHelper.setSp(SfwConstants.tsTxtBoldCommon):fontSize,
        textColor: textColor,
        fontWeight: FontWeight.bold,fontFamily: fontFamily,lineSpace: lineSpace);
  }

  static TextStyle semiBold(
      {double fontSize, Color textColor=SfwColors.txtSemiBoldCommon, FontWeight fontWeight,String fontFamily,double lineSpace}) {
    return create(
        fontSize: fontSize == null ? SfwHelper.setSp(SfwConstants.tsTxtSemiCommon):fontSize,
        textColor: textColor,lineSpace: lineSpace,
        fontWeight: FontWeight.w600,fontFamily: fontFamily);
  }

  static TextStyle medium(
      {double fontSize, Color textColor=SfwColors.txtMediumCommon, FontWeight fontWeight,String fontFamily,double lineSpace}) {
    return create(
        fontSize: fontSize ==null? SfwHelper.setSp(SfwConstants.tsTxtMediumCommon):fontSize,lineSpace: lineSpace,
        textColor: textColor,
        fontWeight: FontWeight.w500,fontFamily: fontFamily);
  }

  static TextStyle italic({double fontSize, Color textColor=SfwColors.txtCommon,String fontFamily,double lineSpace}) {
    return create(
        fontSize: fontSize == null? SfwHelper.setSp(SfwConstants.tsTxtCommon):fontSize,lineSpace: lineSpace,
        textColor: textColor,
        fontStyle: FontStyle.italic,fontFamily: fontFamily);
  }

  static TextStyle italicBold({double fontSize, Color textColor,String fontFamily,double lineSpace}) {
    return TextStyle(
        color: textColor ==null? SfwColors.txtBoldCommon :textColor,
        fontSize: fontSize == null? SfwHelper.setSp(SfwConstants.tsTxtBoldCommon):fontSize,height: lineSpace==null?1:lineSpace,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,fontFamily: fontFamily);
  }

  static TextStyle italicSmall({Color textColor}) {
    return TextStyle(
        color: textColor ==null? SfwColors.txtSmallCommon:textColor,
        fontSize: SfwHelper.setSp(SfwConstants.tsTxtSmallCommon),
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.italic);
  }

  static TextStyle italicBoldSmall({Color textColor}) {
    return TextStyle(
        color: textColor == null ? SfwColors.txtBoldCommon : textColor,
        fontSize: SfwHelper.setSp(SfwConstants.tsTxtSmallCommon),
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic);
  }



  static TextStyle small(
      {double fontSize: SfwConstants.tsTxtSmallCommon, Color textColor,double lineSpace}) {
    return TextStyle(
        color: textColor == null ? SfwColors.txtSmallCommon : textColor,height: lineSpace==null?1:lineSpace,
        fontSize: SfwHelper.setSp(SfwConstants.tsTxtSmallCommon),
        fontWeight: FontWeight.normal);
  }



  static TextStyle button(
      {double fontSize,
        Color textColor,
        FontWeight fontWeight: FontWeight.bold}) {
    return TextStyle(
        color: textColor == null ? SfwColors.btnTxtCommon : textColor,
        fontSize: fontSize ==null ? SfwHelper.setSp(SfwConstants.tsBtnTxtCommon):fontSize,
        fontWeight: fontWeight);
  }
}

class TIL {

  static TextStyle hint() => TextStyle(
      color: SfwColors.edtHint,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtHint),
      fontWeight: FontWeight.normal);

  static TextStyle counter() => TextStyle(
      color: SfwColors.edtCounter,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtCounter),
      fontWeight: FontWeight.normal);

  static TextStyle label({Color fontColor}) => TextStyle(
      color: fontColor==null?SfwColors.edtLabel:fontColor,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtLabel),
      fontWeight: FontWeight.normal);

  static TextStyle error() => TextStyle(
      color: SfwColors.edtError,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtError),
      fontWeight: FontWeight.normal);

  static TextStyle prefix() => TextStyle(
      color: SfwColors.edtPrefix,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtPrefix),
      fontWeight: FontWeight.normal);

  static TextStyle suffix() => TextStyle(
      color: SfwColors.edtSuffix,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtSuffix),
      fontWeight: FontWeight.normal);

  static TextStyle helper() => TextStyle(
      color: SfwColors.edtHelper,
      fontSize: SfwHelper.setSp(SfwConstants.tsEdtHelper),
      fontWeight: FontWeight.normal);

  static InputBorder border({Color color=SfwColors.edtBorderNormal, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) {
    if (isOutline ?? false)
      return OutlineInputBorder(borderRadius: outlineBorderRadius==null?BorderRadius.all(Radius.circular(20)):outlineBorderRadius,
          borderSide: BorderSide(
            color: color == null? SfwColors.dividerColor:color,
          ));
    if(underLineBorderRadius==null)
      return UnderlineInputBorder(
          borderSide: BorderSide(color: color ==null? SfwColors.primaryColor:color)
      );
    return UnderlineInputBorder(
        borderSide: BorderSide(color: color ==null? SfwColors.primaryColor:color),borderRadius: underLineBorderRadius
    );
  }

  static InputBorder enabledBorder({Color color, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) =>
      border(color: color ==null? SfwColors.edtBorderEnabled:color, isOutline: isOutline);

  static InputBorder errorBorder({Color color, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) =>
      border(color: color ==null? SfwColors.edtBorderError:color, isOutline: isOutline);

  static InputBorder disabledBorder({Color color, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) =>
      border(color: color ==null? SfwColors.edtBorderDisabled:color, isOutline: isOutline);

  static InputBorder focusedBorder({Color color, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) =>
      border(color: color ==null? SfwColors.edtBorderFocused:color, isOutline: isOutline);

  static InputBorder focusedErrorBorder(
      {Color color=SfwColors.edtBorderFocusedError, bool isOutline = false,BorderRadius outlineBorderRadius= const BorderRadius.all(Radius.circular(20)),underLineBorderRadius}) =>
      border(color: color, isOutline: isOutline);
}


class AppTheme {
  static final appTheme =
  ThemeData(primarySwatch: SfwColors.primarySwatch, fontFamily: 'Roboto');
  static final bottomMenuTheme = ThemeData(
      canvasColor: Colors.white,
      // sets the active color of the `BottomNavigationBar` if `Brightness` is light
      primaryColor: Colors.red,
      textTheme: TextTheme(
          caption: new TextStyle(color: SfwColors.txtCommon)));
}
