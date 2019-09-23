import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'app_styles.dart';
import 'package:sfw_imports/sfw_imports.dart' show OnClickListener;
import 'sfw.sfw.dart';
import '../values/styles.sfw.dart';
import 'app_ui.dart' show SfwIconData, SfwTextInput, SfwTil, SfwTilTextsRelated;


class UiHelper {
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
        double height = SfwConstants.hBtnCommon,
        double widthFactor = 1,
        EdgeInsetsGeometry padding = const EdgeInsets.only(
            left: SfwConstants.btnPadLeft, right: SfwConstants.btnPadRight)}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: raisedButton(text,
          height: height,
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
    return Container(
        height: height,
        child: RaisedButton(
          elevation: elevation,
          padding: padding,
          color: backgroundColor ?? SfwColors.btnCommonBack,
          shape: border,
          splashColor: splashColor ?? SfwColors.btnCommonSplashBack,
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
            ? null
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
            : WidgetHelper.commonText(text ?? "",
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
              ? Center(child: WidgetHelper.commonProgress())
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
        child: WidgetHelper.loadImage(
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