import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'styles.sfw.dart';
import 'package:sfw_imports/sfw_imports.dart' show OnClickListener;
import 'sfw.sfw.dart';
import 'ui.sfw.dart' show SfwIconData, SfwTextInput, SfwTil, SfwTilTextsRelated;

class SfwUiHelper {
  static Row createNameValueRow(String left, String right,
      {String separator = ":",
        int leftFlex = 5,
        int rightFlex = 8,
        int separatorFlex = 1}) {
    return createNameValueRowWithWidget(
        Text(
          left == null ? "" : left,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: SfwHelper.setSp(40)),
        ),
        Text(
          separator == null ? "" : separator,
          style: TextStyle(fontSize: SfwHelper.setSp(40)),
        ),
        Text(right == null ? "" : right,
            style: TextStyle(fontSize: SfwHelper.setSp(45))));
  }

  static Row createNameValueRowWithWidget(
      Widget left, Widget separator, Widget right,
      {int leftFlex = 5, int rightFlex = 8, int separatorFlex = 1}) {
    return Row(
      children: <Widget>[
        Expanded(flex: leftFlex, child: left),
        separatorFlex < 1
            ? SizedBox(
          width: 1,
        )
            : Expanded(flex: separatorFlex, child: separator),
        Expanded(flex: rightFlex, child: right)
      ],
    );
  }

  static Widget iconTextColumn(SfwIconData icon, String label,
      {Function onPressed, textStyle, ShapeBorder shape}) {
    Widget child = Material(
        color: Colors.transparent,
        shape: shape,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon.icon, size: icon.size, color: icon.tint),
            Text(
              label,
              maxLines: 1,
              style: textStyle == null ? AppTextStyles.normal() : textStyle,
              softWrap: true,
            )
          ],
        ));
    if (onPressed == null) return child;
    return InkWell(
        onTap: OnClickListener(listener: onPressed).onClick,
        splashColor: SfwColors.primaryColor,
        child: child);
  }

  static Widget twoTextColumn(String label1, String label2,
      {TextStyle textStyle1, TextStyle textStyle2}) {
    if (textStyle1 == null) textStyle1 = AppTextStyles.bold();
    if (textStyle2 == null) textStyle2 = AppTextStyles.small();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label1, maxLines: 1, style: textStyle1),
        Text(label2, maxLines: 1, style: textStyle2)
      ],
    );
  }

  static Widget twoTextColumnCircle(
      String label1, String label2, Color circleColor,
      {TextStyle textStyle1, TextStyle textStyle2}) {
    if (textStyle1 == null) textStyle1 = AppTextStyles.bold();
    if (textStyle2 == null) textStyle2 = AppTextStyles.small();
    return Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: SfwHelper.setHeight(50),
                  width: SfwHelper.setWidth(50),
                  decoration: ShapeDecoration(
                      shape: CircleBorder(side: BorderSide(color: circleColor))),
                  child:
                  Center(child: Text(label1, maxLines: 1, style: textStyle1)),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: SfwHelper.setHeight(10)),
                child: Text(label2, maxLines: 1, style: textStyle2))
          ],
        ));
  }

  static Text commonText(String text,
      {Color textColor,
        double textSize,
        TextAlign textAlign,
        int maxLines,
        double lineSpace,
        double textScaleFactor = 1,
        InlineSpan span}) {
    if (span != null) {
      return Text.rich(
        span,
        maxLines: maxLines,
        textScaleFactor: textScaleFactor,
        style: AppTextStyles.normal(
            textColor: textColor, textSize: textSize, lineSpace: lineSpace),
      );
    }
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.normal(
          textColor: textColor, textSize: textSize, lineSpace: lineSpace),
      textAlign: textAlign,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
    );
  }

  static Text boldText(String text,
      {Color textColor,
        double textSize,
        String fontFamily,
        maxLines,
        InlineSpan span}) {
    if (span != null) {
      return Text.rich(
        span,
        maxLines: maxLines,
        style: AppTextStyles.bold(
            textColor: textColor, fontSize: textSize, fontFamily: fontFamily),
      );
    }
    return Text(
      text == null ? "" : text,
      maxLines: maxLines,
      style: AppTextStyles.bold(
          textColor: textColor, fontSize: textSize, fontFamily: fontFamily),
    );
  }

  static Text semiBoldText(String text,
      {Color textColor, int maxLines, double textSize, String fontFamily}) {
    return Text(
      text == null ? "" : text,
      maxLines: maxLines,
      style: AppTextStyles.semiBold(
          textColor: textColor, fontSize: textSize, fontFamily: fontFamily),
    );
  }

  static Text mediumText(String text,
      {Color textColor, double textSize, String fontFamily}) {
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.medium(
          textColor: textColor, fontSize: textSize, fontFamily: fontFamily),
    );
  }

  static Text italicText(String text, {Color textColor}) {
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.italic(textColor: textColor),
    );
  }

  static Text italicBoldText(String text, {Color textColor}) {
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.italicBold(textColor: textColor),
    );
  }

  static Text smallText(String text, {Color textColor}) {
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.small(textColor: textColor),
    );
  }

  static Text italicSmallText(String text, {Color textColor}) {
    return Text(
      text == null ? "" : text,
      style: AppTextStyles.italicSmall(textColor: textColor),
    );
  }

  static Text buttonText(String text, {TextStyle textStyle}) {
    return Text(text == null ? "" : text,
        style: textStyle == null ? AppTextStyles.button() : textStyle);
  }

  static Widget button(String text, VoidCallback onPressed,
      {double elevation = SfwConstants.btnElevation,
        TextStyle textStyle = const TextStyle(
            color: SfwColors.btnTxtCommon, fontWeight: FontWeight.bold),
        backgroundColor,
        ShapeBorder shape,
        Color borderColor = SfwColors.dividerColor,
        Color splashColor,
        double height,
        double widthFactor = 1,
        EdgeInsetsGeometry padding = const EdgeInsets.only(
            left: SfwConstants.btnPadLeft, right: SfwConstants.btnPadRight)}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: raisedButton(text,
          height: height==null?SfwHelper.setHeight(SfwConstants.hBtnCommon):height,
          onPressed: onPressed,
          elevation: elevation,
          textStyle: textStyle,
          backgroundColor: backgroundColor,
          shape: shape,
          borderColor: borderColor,
          splashColor: splashColor,
          padding: padding),
    );
  }

  static Widget raisedButton(String text,
      {@required VoidCallback onPressed,
        double elevation = SfwConstants.btnElevation,
        TextStyle textStyle =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        backgroundColor,
        ShapeBorder shape,
        Color borderColor = SfwColors.dividerColor,
        Color splashColor,
        double height = SfwConstants.hBtnCommon,
        EdgeInsetsGeometry padding = const EdgeInsets.only(
            left: SfwConstants.btnPadLeft, right: SfwConstants.btnPadRight)}) {
    ShapeBorder border = shape != null
        ? shape
        : RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(SfwHelper.pxToDp(50)));
    return SizedBox(
        height: height == null
            ? SfwHelper.setHeight(SfwConstants.hBtnCommon)
            : height,
        child: RaisedButton(
          elevation: elevation,
          padding: padding,
          color: backgroundColor == null
              ? SfwColors.btnCommonBack
              : backgroundColor,
          shape: border,
          splashColor:
          splashColor == null ? SfwColors.btnCommonSplashBack : splashColor,
          child: buttonText(text, textStyle: textStyle),
          onPressed: OnClickListener(listener: onPressed).onClick,
        ));
  }

  static Widget circleWidget(Widget child, double radius, Function onTap,
      {backgroundColor: Colors.transparent,
        Color borderColor = Colors.transparent,
        double borderRadius = 1,
        double elevation = 0,
        BorderStyle borderStyle = BorderStyle.solid,
        splashColor,
        EdgeInsetsGeometry margin,
        EdgeInsetsGeometry padding}) {
    Widget ret = Material(
      elevation: elevation,
      shape: CircleBorder(
          side: BorderSide(color: borderColor, width: borderRadius)),
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        radius: radius,
        splashColor: splashColor == null ? SfwColors.primaryColor : splashColor,
        onTap: onTap == null ? null : OnClickListener(listener: onTap).onClick,
        child: CircleAvatar(
          radius: SfwHelper.pxToDp(radius),
          backgroundColor: Colors.transparent,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
    return margin == null
        ? ret
        : Container(
      margin: margin,
      child: ret,
    );
  }

  static InputDecoration appInputDecoration({
    SfwTil til = const SfwTil(),
  }) {
    return InputDecoration(
      icon: til.icons.icon.widget != null
          ? til.icons.icon.widget
          : (til.icons.icon.icon != null
          ? Padding(
        padding: til.icons.icon.iconPadding,
        child: Icon(
          til.icons.icon.icon,
          size: til.icons.icon.size,
          color: til.icons.icon.tint,
        ),
      )
          : null),
      labelText: til.texts.labelText,
      labelStyle:
      til.styles.labelStyle != null ? til.styles.labelStyle : TIL.label(),
      helperText: til.texts.helperText,
      helperStyle: til.styles.helperStyle != null
          ? til.styles.helperStyle
          : TIL.helper(),
      hintText: til.texts.hintText,
      hintStyle:
      til.styles.hintStyle != null ? til.styles.hintStyle : TIL.hint(),
      hintMaxLines: til.textsRelated.hintMaxLines,
      errorText: til.texts.errorText,
      errorStyle:
      til.styles.errorStyle != null ? til.styles.errorStyle : TIL.error(),
      errorMaxLines: til.textsRelated.errorMaxLines,
      hasFloatingPlaceholder: til.booleans.hasFloatingPlaceholder ?? true,
      isDense: til.booleans.isDense,
      contentPadding: til.decoration.contentPadding != null
          ? til.decoration.contentPadding
          : EdgeInsets.all(0),
      prefixIcon: til.icons.prefixIcon.widget != null
          ? til.icons.prefixIcon.widget
          : til.icons.prefixIcon.icon != null
          ? Icon(til.icons.prefixIcon.icon,
          size: til.icons.prefixIcon.size,
          color: til.icons.prefixIcon.tint)
          : null,
      prefix: til.icons.prefix,
      prefixText: til.texts.prefixText,
      prefixStyle: til.styles.prefixStyle != null
          ? til.styles.prefixStyle
          : TIL.prefix(),
      suffixIcon: til.icons.suffixIcon.widget != null
          ? til.icons.suffixIcon.widget
          : til.icons.suffixIcon.icon != null
          ? Icon(til.icons.suffixIcon.icon,
          size: til.icons.suffixIcon.size,
          color: til.icons.suffixIcon.tint)
          : null,
      suffix: til.icons.suffix,
      suffixText: til.texts.suffixText,
      suffixStyle: til.styles.suffixStyle != null
          ? til.styles.suffixStyle
          : TIL.suffix(),
      counter: til.icons.counter,
      counterText: til.texts.counterText != null
          ? til.texts.counterText
          : ((til.booleans.enableCounter != null
          ? til.booleans.enableCounter
          : false)
          ? null
          : ""),
      counterStyle: til.styles.counterStyle,
      filled: til.booleans.filled,
      fillColor: til.decoration.fillColor,
      errorBorder: til.decoration.errorBorder != null
          ? til.decoration.errorBorder
          : TIL.errorBorder(
          color: til.decoration.errorBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      focusedBorder: til.decoration.focusedBorder != null
          ? til.decoration.focusedBorder
          : TIL.focusedBorder(
          color: til.decoration.focusedBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      focusedErrorBorder: til.decoration.focusedErrorBorder != null
          ? til.decoration.focusedErrorBorder
          : TIL.focusedErrorBorder(
          color: til.decoration.focusedErrorBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      disabledBorder: til.decoration.disabledBorder != null
          ? til.decoration.disabledBorder
          : TIL.disabledBorder(
          color: til.decoration.disabledBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      enabledBorder: til.decoration.enabledBorder != null
          ? til.decoration.enabledBorder
          : TIL.enabledBorder(
          color: til.decoration.enabledBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      border: til.decoration.border != null
          ? til.decoration.border
          : TIL.border(
          color: til.decoration.normalBorderColor,
          isOutline: til.booleans.isOutline,
          outlineBorderRadius: til.decoration.outlineBorderRadius,
          underLineBorderRadius: til.decoration.underlineBorderRadius),
      enabled: til.booleans.enabled != null ? til.booleans.enabled : true,
      semanticCounterText: til.texts.semanticCounterText,
      alignLabelWithHint: til.booleans.alignLabelWithHint,
    );
  }

  static Widget til({SfwTil til = const SfwTil()}) {
    return TextFormField(
        inputFormatters: til.actions.inputFormatters,
        controller: til.actions.controller,
        initialValue: til.texts.text,
        focusNode: til.booleans.enabled != null && !til.booleans.enabled
            ? null
            : til.actions.focusNode,
        decoration: appInputDecoration(til: til),
        keyboardType: til.booleans.enabled != null && !til.booleans.enabled
            ? null
            : til.textProperty.inputType != null
            ? til.textProperty.inputType
            : TextInputType.text,
        textCapitalization: til.textProperty.textCapitalization != null
            ? til.textProperty.textCapitalization
            : TextCapitalization.none,
        textInputAction: til.textProperty.inputAction,
        style: til.styles.style != null
            ? til.styles.style
            : AppTextStyles.normal(),
        strutStyle: til.styles.strutStyle,
        textDirection: til.textProperty.textDirection,
        textAlign: til.styles.textAlign != null
            ? til.styles.textAlign
            : TextAlign.start,
        readOnly: til.booleans.enabled != null && !til.booleans.enabled,
        showCursor: til.booleans.showCursor != null && til.booleans.showCursor,
        maxLines:
        til.textsRelated.maxLines != null ? til.textsRelated.maxLines : 1,
        minLines:
        til.textsRelated.minLines != null && til.textsRelated.minLines < 1
            ? til.textsRelated.maxLines!=null && til.textsRelated.maxLines>1?SfwConstants.edtMultiMinLines:1
            : til.textsRelated.minLines,
        autocorrect:
        til.booleans.autoCorrect != null ? til.booleans.autoCorrect : true,
        autovalidate: til.booleans.autoValidate != null
            ? til.booleans.autoValidate
            : til.actions.validator == null,
        autofocus: til.booleans.autoFocus != null
            ? til.booleans.autoFocus &&
            (til.booleans.enabled != null ? til.booleans.enabled : true)
            : til.booleans.enabled != null ? til.booleans.enabled : true,
        obscureText:
        til.booleans.obscureText != null ? til.booleans.obscureText : false,
        maxLength: til.textsRelated.maxLength != null
            ? til.textsRelated.maxLength
            : SfwConstants.edtMaxLength,
        maxLengthEnforced: til.booleans.maxLengthEnforced != null
            ? til.booleans.maxLengthEnforced
            : true,
        expands: til.booleans.expands != null ? til.booleans.expands : false,
        onEditingComplete: til.actions.onEditingComplete,
        onFieldSubmitted: til.actions.onFieldSubmitted == null &&
            til.actions.focusNode != null
            ? (term) {
          if (til.textProperty.inputAction == null)
            til.actions.focusNode.nextFocus();
          else if (til.textProperty.inputAction ==
              TextInputAction.continueAction ||
              til.textProperty.inputAction ==
                  TextInputAction.unspecified ||
              til.textProperty.inputAction == TextInputAction.next) {
            til.actions.focusNode.nextFocus();
          } else if (til.textProperty.inputAction ==
              TextInputAction.done) {
            til.actions.focusNode.unfocus();
          } else if (til.textProperty.inputAction ==
              TextInputAction.previous) {
            til.actions.focusNode.previousFocus();
          }
        }
            : til.actions.onFieldSubmitted,
        onSaved: til.actions.onSaved,
        validator: til.actions.validator,
        enabled: til.booleans.enabled != null ? til.booleans.enabled : true,
        cursorWidth: til.textProperty.cursorWidth != null
            ? til.textProperty.cursorWidth
            : SfwHelper.pxToDp(2.0),
        cursorRadius: til.textProperty.cursorRadius,
        cursorColor: til.textProperty.cursorColor != null
            ? til.textProperty.cursorColor
            : SfwColors.cursorColor,
        keyboardAppearance: til.textProperty.keyboardAppearance,
        scrollPadding: til.decoration.scrollPadding != null
            ? til.decoration.scrollPadding
            : EdgeInsets.all(SfwHelper.pxToDp(1.0)),
        enableInteractiveSelection:
        til.booleans.enableInteractiveSelection != null
            ? til.booleans.enableInteractiveSelection
            : true,
        buildCounter: til.textProperty.buildCounter);
  }

  static Widget tilMultiCommon({SfwTil sfwTil = const SfwTil()}) => til(
    til: SfwTil(
        actions: sfwTil.actions,
        booleans: sfwTil.booleans,
        icons: sfwTil.icons,
        decoration: sfwTil.decoration,
        texts: sfwTil.texts,
        styles: sfwTil.styles,
        textProperty: sfwTil.textProperty,
        textsRelated: SfwTilTextsRelated(
          hintMaxLines: sfwTil.textsRelated.hintMaxLines,
          minLength: sfwTil.textsRelated.minLength,
          maxLength: SfwConstants.edtMultiMaxLength,
          minLines: SfwConstants.edtMultiMinLines,
          maxLines: SfwConstants.edtMultiMaxLines,
          errorMaxLines: sfwTil.textsRelated.errorMaxLines,
        )),
  );

  static Widget tilMultiCustom({SfwTil sfwTil = const SfwTil()}) =>
      SfwTextInput(
        til: SfwTil(
            actions: sfwTil.actions,
            booleans: sfwTil.booleans,
            icons: sfwTil.icons,
            decoration: sfwTil.decoration,
            texts: sfwTil.texts,
            styles: sfwTil.styles,
            textProperty: sfwTil.textProperty,
            textsRelated: SfwTilTextsRelated(
              hintMaxLines: sfwTil.textsRelated.hintMaxLines,
              minLength: sfwTil.textsRelated.minLength,
              maxLength: SfwConstants.edtMultiMaxLength,
              minLines: SfwConstants.edtMultiMinLines,
              maxLines: SfwConstants.edtMultiMaxLines,
              errorMaxLines: sfwTil.textsRelated.errorMaxLines,
            )),
      );

  static withMarginTop(Widget child,
      {double paddingTop = SfwConstants.commonTopMargin}) =>
      Padding(
        padding: EdgeInsets.only(top: SfwHelper.setHeight(paddingTop)),
        child: child,
      );

  static Widget commonProgress(
      {Color color, bool needOnlyProgressView = false}) {
    if (needOnlyProgressView)
      return SizedBox(
        width: SfwHelper.pxToDp(100.0),
        height: SfwHelper.pxToDp(100.0),
        child: SpinKitPouringHourglass(
          color: color ?? SfwColors.progressWidgetColor,
          size: SfwHelper.pxToDp(100.0),
        ),
      );
    else
      return Center(
        child: SpinKitPouringHourglass(
          color: color ?? SfwColors.progressWidgetColor,
          size: SfwHelper.pxToDp(100.0),
        ),
      );
  }

  static Widget emptyView(
      {Widget child,
        String text,
        TextStyle textStyle,
        IconData image,
        String buttonText,
        TextStyle buttonTextStyle,
        double buttonWidthFactor = .5,
        VoidCallback onButtonPressed}) {
    if (child != null)
      return Center(
        child: child,
      );
    List<Widget> children = [];
    children.add(
      Padding(
        padding: EdgeInsets.only(
            left: SfwHelper.setWidth(30), right: SfwHelper.setWidth(30)),
        child: textStyle != null
            ? Text(
          text ?? "",
          style: textStyle,
          textAlign: TextAlign.center,
        )
            : SfwUiHelper.commonText(text ?? "",
            textAlign: TextAlign.center, textSize: SfwHelper.setSp(40)),
      ),
    );
    if (image != null) {
      children.add(Padding(
        padding: EdgeInsets.only(top: SfwHelper.setHeight(30)),
        child: circleWidget(
            Icon(
              image,
              size: SfwHelper.pxToDp(100),
              color: SfwColors.progressWidgetColor,
            ),
            70,
            onButtonPressed),
      ));
    } else if (buttonText != null && buttonText.trim() != "") {
      children.add(Padding(
        padding: EdgeInsets.only(top: SfwHelper.setHeight(30)),
        child: Padding(
          padding: EdgeInsets.only(
              left: SfwHelper.setWidth(30), right: SfwHelper.setWidth(30)),
          child: button(
            buttonText,
            onButtonPressed,
            textStyle: buttonTextStyle,
            widthFactor: buttonWidthFactor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  SfwHelper.pxToDp(20),
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  static Widget loadImage(String url, double width, double height,
      {bool showDefaultProgressView = false,
        Widget progressView,
        bool showDefaultErrorView = false,
        Widget errorView,
        IconData errorIcon,
        BoxFit fit = BoxFit.cover,
        Color iconTint,
        bool isLocalImage = false,
        bool isAssetImage = false}) {
    Widget errorWidget = showDefaultErrorView
        ? Container(
      width: width,
      height: height,
      child: Center(
          child: Icon(
            errorIcon != null ? errorIcon : Icons.error,
            color:
            iconTint != null ? iconTint : SfwColors.progressWidgetColor,
            size: width > height ? height : width,
          )),
    )
        : errorView;
    if (url == null || url.trim().isEmpty)
      return errorWidget == null
          ? SizedBox(
        width: width != null ? width : 1,
        height: height != null ? height : 1,
      )
          : errorWidget;
    if (isLocalImage != null && isLocalImage) {
      return Image.file(
        File(url),
        height: height,
        width: width,
        fit: fit,
      );
    }

    if (isAssetImage != null && isAssetImage) {
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit,
      );
    }

    return CachedNetworkImage(
      placeholder: (context, url) {
        return Container(
          width: width,
          height: height,
          child: showDefaultProgressView
              ? Center(child: SfwUiHelper.commonProgress())
              : progressView,
        );
      },
      errorWidget: (context, url, error) {
        return errorWidget;
      },
      imageUrl: url,
      fit: fit,
      height: height == null || height < 1 ? null : height,
      width: width == null || width < 1 ? null : width,
    );
  }

  static Widget circleBorderNetworkImage(String url, double height,
      {Color borderColor = SfwColors.progressWidgetColor,
        Color backgroundColor = Colors.transparent,
        bool showDefaultProgressView = false,
        Widget progressView,
        bool showDefaultErrorView = false,
        Widget errorView,
        IconData errorIcon,
        double borderWidth = 2,
        Color iconTint,
        bool isLocalImage = false,
        bool isAssetImage = false}) {
    double h = SfwHelper.setHeight(height);
    double radius = SfwHelper.pxToDp(borderWidth);
    return Container(
      height: h,
      width: h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
              color: borderColor, width: radius, style: BorderStyle.solid)),
      child: ClipOval(
        child: SfwUiHelper.loadImage(
          url,
          h - radius,
          h - radius,
          showDefaultProgressView: showDefaultProgressView,
          showDefaultErrorView: showDefaultErrorView,
          progressView: progressView,
          errorIcon: errorIcon,
          errorView: errorView,
          iconTint: iconTint,
          isLocalImage: isLocalImage,
          isAssetImage: isAssetImage,
        ),
      ),
    );
  }

  static EdgeInsetsGeometry commonEdtPadding() {
    return const EdgeInsets.only(bottom: 20, left: 20, right: 20);
  }
}

class SfwHtmlParser {
  static SfwHtmlParser parser;
  HtmlParser _htmlParser = HtmlParser();

  static SfwHtmlParser getInstance() {
    if (parser == null) {
      parser = SfwHtmlParser();
    }
    return parser;
  }

  TextSpan getSpan(BuildContext context, String data) {
    List nodes = _htmlParser.parse(data);
    return this._stackToTextSpan(nodes, context);
  }

  RichText getWidget(BuildContext context, String data) {
    return RichText(text: getSpan(context, data));
  }

  TextSpan _stackToTextSpan(List nodes, BuildContext context) {
    List<TextSpan> children = <TextSpan>[];

    for (int i = 0; i < nodes.length; i++) {
      children.add(_textSpan(nodes[i]));
    }

    return new TextSpan(
        text: '',
        style: DefaultTextStyle.of(context).style,
        children: children);
  }

  // =================================================================================================================

  TextSpan _textSpan(Map node) {
    TextSpan span = new TextSpan(text: node['text'], style: node['style']);

    return span;
  }
}

class HtmlParser {
  // Regular Expressions for parsing tags and attributes
  RegExp _startTag;
  RegExp _endTag;
  RegExp _attr;
  RegExp _style;
  RegExp _color;

  final List _emptyTags = const [
    'area',
    'base',
    'basefont',
    'br',
    'col',
    'frame',
    'hr',
    'img',
    'input',
    'isindex',
    'link',
    'meta',
    'param',
    'embed'
  ];
  final List _blockTags = const [
    'address',
    'applet',
    'blockquote',
    'button',
    'center',
    'dd',
    'del',
    'dir',
    'div',
    'dl',
    'dt',
    'fieldset',
    'form',
    'frameset',
    'hr',
    'iframe',
    'ins',
    'isindex',
    'li',
    'map',
    'menu',
    'noframes',
    'noscript',
    'object',
    'ol',
    'p',
    'pre',
    'script',
    'table',
    'tbody',
    'td',
    'tfoot',
    'th',
    'thead',
    'tr',
    'ul'
  ];
  final List _inlineTags = const [
    'a',
    'abbr',
    'acronym',
    'applet',
    'b',
    'basefont',
    'bdo',
    'big',
    'br',
    'button',
    'cite',
    'code',
    'del',
    'dfn',
    'em',
    'font',
    'i',
    'iframe',
    'img',
    'input',
    'ins',
    'kbd',
    'label',
    'map',
    'object',
    'q',
    's',
    'samp',
    'script',
    'select',
    'small',
    'span',
    'strike',
    'strong',
    'sub',
    'sup',
    'textarea',
    'tt',
    'u',
    'var'
  ];
  final List _closeSelfTags = const [
    'colgroup',
    'dd',
    'dt',
    'li',
    'options',
    'p',
    'td',
    'tfoot',
    'th',
    'thead',
    'tr'
  ];
  final List _fillAttrs = const [
    'checked',
    'compact',
    'declare',
    'defer',
    'disabled',
    'ismap',
    'multiple',
    'nohref',
    'noresize',
    'noshade',
    'nowrap',
    'readonly',
    'selected'
  ];
  final List _specialTags = const ['script', 'style'];

  List _stack = [];
  List _result = [];

  Map<String, dynamic> _tag;

  // =================================================================================================================

  HtmlParser() {
    this._startTag = new RegExp(
        r'^<([-A-Za-z0-9_]+)((?:\s+\w+(?:\s*=\s*(?:(?:"[^"]*")' +
            "|(?:'[^']*')|[^>\s]+))?)*)\s*(\/?)>");
    this._endTag = new RegExp("^<\/([-A-Za-z0-9_]+)[^>]*>");
    this._attr = new RegExp(
        r'([-A-Za-z0-9_]+)(?:\s*=\s*(?:(?:"((?:\\.|[^"])*)")' +
            r"|(?:'((?:\\.|[^'])*)')|([^>\s]+)))?");
    this._style = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    this._color = new RegExp(r'^#([a-fA-F0-9]{6})$');
  }

  // =================================================================================================================

  List parse(String html) {
    String last = html;
    Match match;
    int index;
    bool chars;

    while (html.length > 0) {
      chars = true;

      // Make sure we're not in a script or style element
      if (this._getStackLastItem() == null ||
          !this._specialTags.contains(this._getStackLastItem())) {
        // Comment
        if (html.indexOf('<!--') == 0) {
          index = html.indexOf('-->');

          if (index >= 0) {
            html = html.substring(index + 3);
            chars = false;
          }
        }
        // End tag
        else if (html.indexOf('</') == 0) {
          match = this._endTag.firstMatch(html);

          if (match != null) {
            String tag = match[0];

            html = html.substring(tag.length);
            chars = false;

            this._parseEndTag(tag);
          }
        }
        // Start tag
        else if (html.indexOf('<') == 0) {
          match = this._startTag.firstMatch(html);

          if (match != null) {
            String tag = match[0];

            html = html.substring(tag.length);
            chars = false;

            this._parseStartTag(tag, match[1], match[2], match.start);
          }
        }

        if (chars) {
          index = html.indexOf('<');

          String text = (index < 0) ? html : html.substring(0, index);

          html = (index < 0) ? '' : html.substring(index);

          this._appendNode(text);
        }
      } else {
        RegExp re =
        new RegExp(r'(.*)<\/' + this._getStackLastItem() + r'[^>]*>');

        html = html.replaceAllMapped(re, (Match match) {
          String text = match[0]
            ..replaceAll(new RegExp('<!--(.*?)-->'), '\$1')
            ..replaceAll(new RegExp('<!\[CDATA\[(.*?)]]>'), '\$1');

          this._appendNode(text);

          return '';
        });

        this._parseEndTag(this._getStackLastItem());
      }

      if (html == last) {
        throw 'Parse Error: ' + html;
      }

      last = html;
    }

    // Cleanup any remaining tags
    this._parseEndTag();

    List result = this._result;

    // Cleanup internal variables
    this._stack = [];
    this._result = [];

    return result;
  }

  // =================================================================================================================

  void _parseStartTag(String tag, String tagName, String rest, int unary) {
    tagName = tagName.toLowerCase();

    if (this._blockTags.contains(tagName)) {
      while (this._getStackLastItem() != null &&
          this._inlineTags.contains(this._getStackLastItem())) {
        this._parseEndTag(this._getStackLastItem());
      }
    }

    if (this._closeSelfTags.contains(tagName) &&
        this._getStackLastItem() == tagName) {
      this._parseEndTag(tagName);
    }

    if (this._emptyTags.contains(tagName)) {
      unary = 1;
    }

    if (unary == 0) {
      this._stack.add(tagName);
    }

    Map attrs = {};

    Iterable<Match> matches = this._attr.allMatches(rest);

    if (matches != null) {
      for (Match match in matches) {
        String attribute = match[1];
        String value;

        if (match[2] != null) {
          value = match[2];
        } else if (match[3] != null) {
          value = match[3];
        } else if (match[4] != null) {
          value = match[4];
        } else if (this._fillAttrs.contains(attribute) != null) {
          value = attribute;
        }

        attrs[attribute] = value;
      }
    }

    this._appendTag(tagName, attrs);
  }

  // =================================================================================================================

  void _parseEndTag([String tagName]) {
    int pos;

    // If no tag name is provided, clean shop
    if (tagName == null) {
      pos = 0;
    }
    // Find the closest opened tag of the same type
    else {
      for (pos = this._stack.length - 1; pos >= 0; pos--) {
        if (this._stack[pos] == tagName) {
          break;
        }
      }
    }

    if (pos >= 0) {
      // Remove the open elements from the stack
      this._stack.removeRange(pos, this._stack.length);
    }
  }

  // =================================================================================================================

  TextStyle _parseStyle(String tag, Map attrs) {
    Iterable<Match> matches;
    String style = attrs['style'];
    String param;
    String value;

    Color color = new Color(0xFF000000);
    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.normal;
    TextDecoration textDecoration = TextDecoration.none;

    switch (tag) {
      case 'a':
        color = new Color(int.parse('0xFF1965B5'));
        break;

      case 'b':
      case 'strong':
        fontWeight = FontWeight.bold;
        break;

      case 'i':
      case 'em':
        fontStyle = FontStyle.italic;
        break;

      case 'u':
        textDecoration = TextDecoration.underline;
        break;
    }

    if (style != null) {
      matches = this._style.allMatches(style);

      for (Match match in matches) {
        param = match[1].trim();
        value = match[2].trim();

        switch (param) {
          case 'color':
            if (this._color.hasMatch(value)) {
              value = value.replaceAll('#', '').trim();
              color = new Color(int.parse('0xFF' + value));
            }

            break;

          case 'font-weight':
            fontWeight =
            (value == 'bold') ? FontWeight.bold : FontWeight.normal;

            break;

          case 'font-style':
            fontStyle =
            (value == 'italic') ? FontStyle.italic : FontStyle.normal;

            break;

          case 'text-decoration':
            textDecoration = (value == 'underline')
                ? TextDecoration.underline
                : TextDecoration.none;

            break;
        }
      }
    }

    TextStyle textStyle = new TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: textDecoration);

    return textStyle;
  }

  // =================================================================================================================

  void _appendTag(String tag, Map attrs) {
    this._tag = {'tag': tag, 'attrs': attrs};
  }

  // =================================================================================================================

  void _appendNode(String text) {
    if (this._tag == null) {
      this._tag = {'tag': 'p', 'attrs': {}};
    }

    this._tag['text'] = text;
    this._tag['style'] = this._parseStyle(this._tag['tag'], this._tag['attrs']);
    this._tag['href'] =
    (this._tag['attrs']['href'] != null) ? this._tag['attrs']['href'] : '';

    this._tag.remove('attrs');

    this._result.add(this._tag);

    this._tag = null;
  }

  // =================================================================================================================

  String _getStackLastItem() {
    if (this._stack.length <= 0) {
      return null;
    }

    return this._stack[this._stack.length - 1];
  }
}
