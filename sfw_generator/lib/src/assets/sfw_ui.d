import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'strings.sfw.dart';
import 'styles.sfw.dart';
import 'package:sfw_imports/sfw_imports.dart' show OnClickCallback2, Validator;
import 'package:flutter/material.dart';
import 'ui_helper.sfw.dart';
import 'sfw.sfw.dart';

class ProgressButtonModel {
  ProgressButtonStates state;
  String text;
  OnClickCallback2 onPressed;
  int milliSecondsToNormal;
  int id;
  double elevation;
  TextStyle textStyle;

  final Color backgroundColor;
  final Color splashColor;
  final ShapeBorder shape;
  final Color borderColor;

  final double height;

  final double widthFactor ;
  final EdgeInsetsGeometry padding;
  final Color progressColor;
  final Widget progressWidget;
  SfwIconData successWidget;

  ProgressButtonModel(this.text, this.onPressed,
      {this.state = ProgressButtonStates.normal,
        this.milliSecondsToNormal = -1,
        this.id = 0,
        this.elevation = SfwConstants.btnElevation,
        this.textStyle = const TextStyle(
            color: SfwColors.btnTxtCommon, fontWeight: FontWeight.bold),
        this.backgroundColor,
        this.shape,
        this.borderColor = SfwColors.dividerColor,
        this.splashColor=SfwColors.btnCommonSplashBack,
        this.successWidget,
        this.progressColor=SfwColors.accentColor,
        this.progressWidget,
        this.height = SfwConstants.hBtnCommon,
        this.widthFactor = 1,
        this.padding = const EdgeInsets.only(
            left: SfwConstants.btnPadLeft, right: SfwConstants.btnPadRight),
      });

  String get listenerKey => "$listenerKeySuffix$id";

  static String get listenerKeySuffix => "ProgressButton";
}

class SfwIconData {
  final IconData icon;
  final double size;
  final Color tint;
  final Color focusTint;
  final EdgeInsets iconPadding;
  final Widget widget;
  final VoidCallback onPressed;

  const SfwIconData(
      {this.icon,
        this.tint,
        this.focusTint,
        this.widget,
        this.iconPadding = const EdgeInsets.only(
            left: SfwConstants.edtIconPaddingLeft,
            right: SfwConstants.edtIconPaddingRight),
        this.size = SfwConstants.edtIconSize,
        this.onPressed});
}

class SfwTil {
  final SfwTilIcons icons;
  final SfwTilStyles styles;
  final SfwTilText texts;
  final SfwTilDecoration decoration;
  final SfwTilBool booleans;
  final SfwTilActions actions;
  final SfwTilTextProperty textProperty;
  final SfwTilTextsRelated textsRelated;
  final double height;
  final double width;
  final Alignment alignment;
  final bool isWHpercentage;

  const SfwTil(
      {this.icons = const SfwTilIcons(),
        this.styles = const SfwTilStyles(),
        this.texts = const SfwTilText(),
        this.decoration = const SfwTilDecoration(),
        this.booleans = const SfwTilBool(),
        this.actions = const SfwTilActions(),
        this.textProperty = const SfwTilTextProperty(),
        this.textsRelated = const SfwTilTextsRelated(),
        this.height,
        this.width,
        this.alignment,
        this.isWHpercentage = false});
}

class SfwTilStyles {
  final TextStyle style;
  final TextStyle helperStyle;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextStyle errorStyle;
  final TextStyle prefixStyle;
  final TextStyle suffixStyle;
  final TextStyle counterStyle;

  final StrutStyle strutStyle;
  final TextAlign textAlign;

  const SfwTilStyles({
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.helperStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.prefixStyle,
    this.suffixStyle,
    this.counterStyle,
  });
}

class SfwTilTextProperty {
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextDirection textDirection;

  final TextCapitalization textCapitalization;
  final Color cursorColor;
  final double cursorWidth;
  final Radius cursorRadius;
  final Brightness keyboardAppearance;

  final InputCounterWidgetBuilder buildCounter;

  const SfwTilTextProperty({
    this.cursorColor,
    this.cursorWidth,
    this.cursorRadius,
    this.keyboardAppearance,
    this.buildCounter,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.textDirection,
    this.textCapitalization = TextCapitalization.none,
  });
}

class SfwTilText {
  final String labelText;
  final String helperText;
  final String hintText;
  final String errorText;
  final String text;
  final String counterText;
  final String suffixText;
  final String prefixText;
  final String semanticCounterText;

  const SfwTilText({
    this.labelText,
    this.helperText,
    this.hintText,
    this.errorText,
    this.text,
    this.counterText,
    this.suffixText,
    this.prefixText,
    this.semanticCounterText,
  });

  SfwTilText copyWith(
      {String labelText,
        String helperText,
        String hintText,
        String errorText,
        String text,
        String counterText,
        String suffixText,
        String prefixText,
        String semanticCounterText}) {
    return SfwTilText(
        labelText: labelText ?? this.labelText,
        helperText: helperText ?? this.helperText,
        hintText: hintText ?? this.hintText,
        errorText: errorText ?? this.errorText,
        text: text ?? this.text,
        counterText: counterText ?? this.counterText,
        suffixText: suffixText ?? this.suffixText,
        prefixText: prefixText ?? this.prefixText,
        semanticCounterText: semanticCounterText ?? this.semanticCounterText);
  }
}

class SfwTilTextsRelated {
  final int hintMaxLines;
  final int errorMaxLines;
  final int maxLength;
  final int minLength;
  final int maxLines;
  final int minLines;

  const SfwTilTextsRelated(
      {this.hintMaxLines,
        this.errorMaxLines,
        this.maxLength = SfwConstants.edtMaxLength,
        this.minLength = 0,
        this.maxLines = 1,
        this.minLines});

  static SfwTilTextsRelated multiLine(SfwTilTextsRelated texts) =>
      SfwTilTextsRelated(
          hintMaxLines: texts.hintMaxLines,
          errorMaxLines: texts.errorMaxLines,
          maxLength: SfwConstants.edtMultiMaxLength,
          maxLines: SfwConstants.edtMultiMaxLines,
          minLines: SfwConstants.edtMultiMinLines);

  static SfwTilTextsRelated password(SfwTilTextsRelated texts) =>
      SfwTilTextsRelated(
          hintMaxLines: texts.hintMaxLines,
          errorMaxLines: texts.errorMaxLines,
          maxLength: SfwConstants.edtPasswordMaxLength,
          minLength: SfwConstants.edtPasswordMinLength);
}

class SfwTilIcons {
  final SfwIconData passwordHiddenIcon;
  final SfwIconData passwordShowIcon;
  final SfwIconData prefixIcon;
  final SfwIconData suffixIcon;
  final SfwIconData icon;
  final Widget prefix;
  final Widget suffix;
  final Widget counter;

  const SfwTilIcons({
    this.passwordHiddenIcon = const SfwIconData(),
    this.passwordShowIcon = const SfwIconData(),
    this.prefixIcon = const SfwIconData(),
    this.suffixIcon = const SfwIconData(),
    this.icon = const SfwIconData(),
    this.prefix,
    this.suffix,
    this.counter,
  });
}

class SfwTilActions {
  final TextEditingController controller;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final FocusNode focusNode;
  final List<TextInputFormatter> inputFormatters;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;

  const SfwTilActions(
      {this.controller,
        this.onSaved,
        this.validator,
        this.focusNode,
        this.inputFormatters,
        this.onEditingComplete,
        this.onFieldSubmitted});

  SfwTilActions copyWith({
    TextEditingController controller,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    FocusNode focusNode,
    List<TextInputFormatter> inputFormatters,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
  }) {
    return SfwTilActions(
      controller: controller ?? this.controller,
      onSaved: onSaved ?? this.onSaved,
      validator: validator ?? this.validator,
      focusNode: focusNode ?? this.focusNode,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
    );
  }
}

class SfwTilBool {
  final bool obscureText;

  final bool maxLengthEnforced;

  final bool expands;

  final bool enabled;
  final bool enableInteractiveSelection;
  final bool hasFloatingPlaceholder;
  final bool isDense;
  final bool filled;
  final bool alignLabelWithHint;
  final bool isOutline;
  final bool autoCorrect;
  final bool autoValidate;
  final bool autoFocus;
  final bool showPasswordToggleIcon;
  final bool enableCounter;
  final bool showCursor;

  const SfwTilBool(
      {this.enableCounter = false,
        this.showPasswordToggleIcon = false,
        this.autoCorrect = true,
        this.autoValidate = false,
        this.autoFocus = false,
        this.obscureText = false,
        this.maxLengthEnforced = true,
        this.expands = false,
        this.enabled = true,
        this.enableInteractiveSelection = true,
        this.hasFloatingPlaceholder = true,
        this.showCursor = true,
        this.isDense,
        this.filled,
        this.alignLabelWithHint,
        this.isOutline = false});
}

class SfwTilDecoration {
  final Color fillColor;
  final Color focusColor;
  final Color hoverColor;
  final Color errorBorderColor;
  final Color focusedBorderColor;
  final Color focusedErrorBorderColor;
  final Color disabledBorderColor;
  final Color enabledBorderColor;
  final Color normalBorderColor;

  final InputBorder errorBorder;
  final InputBorder focusedBorder;
  final InputBorder focusedErrorBorder;
  final InputBorder enabledBorder;
  final InputBorder disabledBorder;
  final InputBorder border;
  final EdgeInsets contentPadding;
  final EdgeInsets scrollPadding;
  final BorderRadius outlineBorderRadius;
  final BorderRadius underlineBorderRadius;

  const SfwTilDecoration(
      {this.scrollPadding = const EdgeInsets.all(20.0),
        this.fillColor,
        this.focusColor,
        this.hoverColor,
        this.errorBorderColor,
        this.focusedBorderColor,
        this.focusedErrorBorderColor,
        this.disabledBorderColor,
        this.enabledBorderColor,
        this.normalBorderColor,
        this.errorBorder,
        this.focusedBorder,
        this.focusedErrorBorder,
        this.enabledBorder,
        this.disabledBorder,
        this.border,
        this.contentPadding,
        this.outlineBorderRadius,
        this.underlineBorderRadius});
}

class TilPassword extends StatefulWidget {
  final SfwTil til;
  final bool isPasswordVisible;

  @override
  State<StatefulWidget> createState() {
    return _TilPasswordState();
  }

  TilPassword({
    Key key,
    this.til = const SfwTil(),
    this.isPasswordVisible = false,
  });
}

class _TilPasswordState extends State<TilPassword> {
  bool _isPasswordVisible = false;
  bool _showError = false;
  bool _isSuffixIconNull = false;
  FocusNode _focusNode = FocusNode();

  //bool _errorShowing = false;
  String _errorText;

  _TilPasswordState();

  changeState() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  void initState() {
    this._isSuffixIconNull = widget.til.icons.suffixIcon == null ||
        (widget.til.icons.suffixIcon.icon == null &&
            widget.til.icons.suffixIcon.widget == null);
    this._isPasswordVisible = widget.isPasswordVisible ?? false;
    if (widget.til.actions.focusNode != null)
      this._focusNode = widget.til.actions.focusNode;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showError = false;
        });
      }
    });
    super.initState();
  }

  changeStateOnLongPress(LongPressStartDetails details) {
    changeState();
  }

  @override
  Widget build(BuildContext context) {
    IconData icon;
    this._errorText = widget.til.texts.errorText != null
        ? widget.til.texts.errorText
        : SfwStrings.get(SfwStrings.ERR_PASSWORD);

    if (_isSuffixIconNull &&
        widget.til.booleans.showPasswordToggleIcon != null &&
        widget.til.booleans.showPasswordToggleIcon) {
      if (_isPasswordVisible) {
        icon = (widget.til.icons.passwordHiddenIcon == null ||
            widget.til.icons.passwordHiddenIcon.icon == null)
            ? Icons.visibility_off
            : widget.til.icons.passwordHiddenIcon.icon;
      } else {
        icon = (widget.til.icons.passwordShowIcon == null ||
            widget.til.icons.passwordShowIcon.icon == null)
            ? Icons.visibility
            : widget.til.icons.passwordHiddenIcon.icon;
      }
    }

    return SfwTextInput(
      til: SfwTil(
          width: widget.til.width,
          height: widget.til.height,
          alignment: widget.til.alignment,
          isWHpercentage: widget.til.isWHpercentage,
          decoration: widget.til.decoration,
          styles: widget.til.styles,
          textProperty: widget.til.textProperty,
          textsRelated: widget.til.textsRelated,
          icons: (widget.til.booleans.showPasswordToggleIcon != null &&
              widget.til.booleans.showPasswordToggleIcon)
              ? SfwTilIcons(
            counter: widget.til.icons.counter,
            icon: widget.til.icons.icon,
            prefix: widget.til.icons.prefix,
            suffix: widget.til.icons.suffix,
            prefixIcon: widget.til.icons.prefixIcon,
            suffixIcon: icon == null
                ? widget.til.icons.suffixIcon == null
                ? SfwIconData()
                : widget.til.icons.suffixIcon
                : SfwIconData(
                size: widget.til.icons.suffixIcon.size,
                icon: icon,
                tint: widget.til.icons.suffixIcon.tint,
                onPressed: changeState),
          )
              : widget.til.icons,
          texts: SfwTilText(
            text: widget.til.texts.text,
            errorText: _showError == true ? _errorText : null,
            hintText: widget.til.texts.hintText,
            helperText: widget.til.texts.helperText,
            labelText: widget.til.texts.labelText ??
                SfwStrings.get(SfwStrings.PASSWORD),
            counterText: widget.til.texts.counterText,
            prefixText: widget.til.texts.prefixText,
            semanticCounterText: widget.til.texts.semanticCounterText,
            suffixText: widget.til.texts.suffixText,
          ),
          booleans: SfwTilBool(
              autoValidate: widget.til.booleans.autoValidate,
              isOutline: widget.til.booleans.isOutline,
              alignLabelWithHint: widget.til.booleans.alignLabelWithHint,
              autoCorrect: widget.til.booleans.autoCorrect,
              autoFocus: widget.til.booleans.autoFocus,
              enableCounter: widget.til.booleans.enableCounter,
              enabled: widget.til.booleans.enabled,
              enableInteractiveSelection:
              widget.til.booleans.enableInteractiveSelection,
              expands: widget.til.booleans.expands,
              filled: widget.til.booleans.filled,
              hasFloatingPlaceholder:
              widget.til.booleans.hasFloatingPlaceholder,
              isDense: widget.til.booleans.isDense,
              maxLengthEnforced: widget.til.booleans.maxLengthEnforced,
              obscureText: !_isPasswordVisible,
              showPasswordToggleIcon:
              widget.til.booleans.showPasswordToggleIcon),
          actions: SfwTilActions(
            controller: widget.til.actions.controller,
            inputFormatters: widget.til.actions.inputFormatters,
            onEditingComplete: widget.til.actions.onEditingComplete,
            onFieldSubmitted: widget.til.actions.onFieldSubmitted,
            onSaved: widget.til.actions.onSaved,
            validator: widget.til.actions.validator ??
                    (String text) {
                  return Validator.isValidPassword(text) ? null : _errorText;
                },
            focusNode: _focusNode,
          )),
    );
  }
}

class ProgressButton extends StatefulWidget {
  final ProgressButtonModel model;
  final String stateKey;

  @override
  State<StatefulWidget> createState() {
    return _ProgressButtonState();
  }

  /// milliSecondsToNormal -> set -1 to avoid the button state is reset to normal
  ProgressButton(
      this.model,
      [this.stateKey,]
      ):assert(model!=null);
}

enum ProgressButtonStates { normal, success, progress }

class _ProgressButtonState extends State<ProgressButton> implements SfwNotifierListener {
  ProgressButtonModel _model;

  _ProgressButtonState();

  @override
  void onSfwNotifierCalled(String key, data) {
    if(data is ProgressButtonModel) {
      _model.text=data.text==null?_model.text:data.text;
      _model.state=data.state==null?_model.state:data.state;
      setState(() {

      });
    }
  }

  @override
  void initState() {
    this._model = widget.model;
    if(_model.successWidget==null  ) {
      _model.successWidget=SfwIconData(widget:Icon( Icons.check,size: SfwHelper.setHeight(_model.height==null?SfwConstants.hBtnCommon:_model.height), color: SfwColors.accentColor));
    } else if(_model.successWidget.widget==null) {
      _model.successWidget=SfwIconData(widget:Icon( _model.successWidget.icon==null?Icons.check:_model.successWidget.icon,size: _model.successWidget.size!=null?_model.successWidget.size:SfwHelper.setHeight(_model.height==null?SfwConstants.hBtnCommon:_model.height), color: _model.successWidget.tint==null?SfwColors.accentColor:_model.successWidget.tint));
    }

    SfwNotifierForSingleKey.addListener(this, widget.stateKey);

    if (_model.state != ProgressButtonStates.normal &&
        _model.milliSecondsToNormal > -1)
      runTimer(_model.milliSecondsToNormal, ProgressButtonStates.normal);

    super.initState();
  }

  @override
  void dispose() {
    SfwNotifierForSingleKey.removeListener(this, widget.stateKey);
    super.dispose();
  }

  /*@override
  void didUpdateWidget(ProgressButton oldWidget) {
    _model = widget.model;
    super.didUpdateWidget(oldWidget);
  }*/

  void changeState(ProgressButtonStates state) {
    setState(() {
      _model.state = state;
    });
  }

  void runTimer(int milliSeconds, ProgressButtonStates toState) {
    if (milliSeconds != null && milliSeconds > -1)
      Timer(Duration(milliseconds: milliSeconds), () {
        changeState(toState);
      });
  }

  @override
  Widget build(BuildContext context) {
    switch (_model.state) {
      case ProgressButtonStates.progress:
        return Center(child: _model.progressWidget!=null?_model.progressWidget:CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_model.progressColor==null?SfwColors.accentColor:_model.progressColor),
        ),);
      case ProgressButtonStates.success:
        return Center(child: _model.successWidget.widget);
      default:
        return SfwUiHelper.button(_model.text, () async {
          setState(() {
            _model.state = ProgressButtonStates.progress;
          });
          if (_model.onPressed == null || !await _model.onPressed()) {
            runTimer(1000, ProgressButtonStates.normal);
          }
        },height: _model.height==null?null:SfwHelper.setHeight(_model.height),backgroundColor: _model.backgroundColor,shape: _model.shape,splashColor: _model.splashColor,widthFactor: _model.widthFactor,padding: _model.padding,borderColor: _model.borderColor,textStyle: _model.textStyle,elevation: _model.elevation);
    }
  }
}

class SfwTextInput extends StatefulWidget {
  final SfwTil til;

  const SfwTextInput({Key key, this.til = const SfwTil()}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SfwTextInputState();
  }
}

class _SfwTextInputState extends State<SfwTextInput> {
  FocusNode _focusNode;
  bool isFocused = false;
  Color tilNormalColor, tilFocusedColor;
  TextEditingController controller;

  bool isTextEmpty = true;
  double _leftPadding = 0;
  double _rightPadding = 0;
  double _iconRightMargin = 0;
  double _iconSize;

  double _iconLeftPadding;

  double _iconRightPadding;

  double _iconBottomPadding;

  double _iconTopPadding;

  double _prefixIconSize;

  double _prefixIconLeftPadding;

  double _prefixIconRightPadding;

  double _prefixIconBottomPadding;

  double _prefixIconTopPadding;

  double _suffixIconSize;

  double _suffixIconLeftPadding;

  double _suffixIconRightPadding;

  double _suffixIconBottomPadding;

  double _suffixIconTopPadding;

  @override
  void didUpdateWidget(SfwTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
//    print("con=${controller.text} wid=${widget.til.texts.text}" );
    if (controller.text != widget.til.texts.text &&
        oldWidget.til.texts.text != widget.til.texts.text) {
      controller.text =
      widget.til.texts.text == null ? "" : widget.til.texts.text;
      controller.selection = TextSelection(
          baseOffset: controller.text == null ? 0.0 : controller.text.length,
          extentOffset: controller.text == null ? 0.0 : controller.text.length);
    }
  }

  @override
  void initState() {
    if (widget.til.icons.icon != null ||
        widget.til.icons.prefixIcon != null ||
        widget.til.icons.suffixIcon != null) {
      controller = widget.til.actions.controller == null
          ? TextEditingController()
          : widget.til.actions.controller;
      controller.addListener(() {
        if (!isTextEmpty &&
            (controller.text == null || controller.text.isEmpty)) {
          setState(() {
            isTextEmpty = true;
          });
        } else if (isTextEmpty &&
            controller.text != null &&
            controller.text.isNotEmpty) {
          setState(() {
            isTextEmpty = false;
          });
        }
      });
      controller.text = widget.til.texts.text;
    }
    tilFocusedColor = widget.til.decoration.focusedBorder == null
        ? null
        : widget.til.decoration.focusedBorder.borderSide.color;
    tilNormalColor = widget.til.decoration.border == null
        ? null
        : widget.til.decoration.border.borderSide.color;
    _focusNode = widget.til.actions.focusNode == null
        ? FocusNode()
        : widget.til.actions.focusNode;
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
    _iconSize = widget.til.icons.icon.size == null
        ? SfwConstants.edtIconSize
        : widget.til.icons.icon.size;
    _iconLeftPadding = widget.til.icons.icon.iconPadding.left == null
        ? 0
        : widget.til.icons.icon.iconPadding.left;
    _iconRightPadding = widget.til.icons.icon.iconPadding.right == null
        ? 0
        : widget.til.icons.icon.iconPadding.right;
    _iconBottomPadding = widget.til.icons.icon.iconPadding.bottom == null
        ? 0
        : widget.til.icons.icon.iconPadding.bottom;
    _iconTopPadding = widget.til.icons.icon.iconPadding.top == null
        ? 0
        : widget.til.icons.icon.iconPadding.top;

    _prefixIconSize = widget.til.icons.prefixIcon.size == null
        ? SfwConstants.edtIconSize
        : widget.til.icons.prefixIcon.size;
    _prefixIconLeftPadding =
    widget.til.icons.prefixIcon.iconPadding.left == null
        ? 0
        : widget.til.icons.prefixIcon.iconPadding.left;
    _prefixIconRightPadding =
    widget.til.icons.prefixIcon.iconPadding.right == null
        ? SfwConstants.edtIconPaddingRight
        : widget.til.icons.prefixIcon.iconPadding.right;
    _prefixIconBottomPadding =
    widget.til.icons.prefixIcon.iconPadding.bottom != null
        ? widget.til.icons.prefixIcon.iconPadding.bottom
        : 0;
    _prefixIconTopPadding = widget.til.icons.prefixIcon.iconPadding.top != null
        ? widget.til.icons.prefixIcon.iconPadding.top
        : 0;

    _suffixIconSize = widget.til.icons.suffixIcon.size == null
        ? SfwConstants.edtIconSize
        : widget.til.icons.suffixIcon.size;
    _suffixIconLeftPadding =
    widget.til.icons.prefixIcon.iconPadding.left == null
        ? SfwConstants.edtIconPaddingLeft
        : widget.til.icons.prefixIcon.iconPadding.left;
    _suffixIconRightPadding =
    widget.til.icons.suffixIcon.iconPadding.right == null
        ? 0
        : widget.til.icons.suffixIcon.iconPadding.right;
    _suffixIconBottomPadding =
    widget.til.icons.suffixIcon.iconPadding.bottom != null
        ? widget.til.icons.suffixIcon.iconPadding.bottom
        : 0;
    _suffixIconTopPadding = widget.til.icons.suffixIcon.iconPadding.top == null
        ? 0
        : widget.til.icons.suffixIcon.iconPadding.top;

    if (widget.til.icons.prefixIcon.icon != null ||
        widget.til.icons.prefixIcon.widget != null) {
      _leftPadding +=
          _prefixIconSize + _prefixIconLeftPadding + _prefixIconRightPadding;
    }

    if (widget.til.icons.suffixIcon.icon != null ||
        widget.til.icons.suffixIcon.widget != null) {
      _rightPadding +=
          _suffixIconSize + _suffixIconLeftPadding + _suffixIconRightPadding;
    }
    if (_leftPadding == 0) {
      _leftPadding = SfwConstants.edtLeftPadding;
    }
    if (_rightPadding == 0) {
      _rightPadding = SfwConstants.edtRightPadding;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> row = [];
    List<Widget> stackChildren = [];

    double topBottom = widget.til.isWHpercentage != null &&
        !widget.til.isWHpercentage &&
        widget.til.height != null &&
        widget.til.height > 0
        ? widget.til.height / 2
        : 0;

    final padding = widget.til.decoration.contentPadding == null
        ? EdgeInsets.only(
        left: SfwHelper.setWidth(_leftPadding),
        right: SfwHelper.setWidth(_rightPadding),
        bottom: SfwHelper.setHeight(widget.til.booleans.isOutline == null ||
            !widget.til.booleans.isOutline
            ? SfwConstants.edtBottomPadding
            : SfwConstants.edtBottomPaddingWhenUsingOutline +
            SfwConstants.edtIconSize -
            20) +
            topBottom,
        top: topBottom)
        : EdgeInsets.only(
        left: widget.til.decoration.contentPadding.left,
        top: widget.til.decoration.contentPadding.top == null
            ? topBottom
            : widget.til.decoration.contentPadding.top + topBottom,
        right: widget.til.decoration.contentPadding.right,
        bottom: widget.til.decoration.contentPadding.bottom == null
            ? topBottom
            : widget.til.decoration.contentPadding.bottom + topBottom);

    if (widget.til.icons.icon.icon != null ||
        widget.til.icons.icon.widget != null) {
      Color iconColor = _focusNode.hasFocus
          ? widget.til.icons.icon.focusTint == null
          ? SfwColors.edtIconFocused == null
          ? tilFocusedColor
          : SfwColors.edtIconFocused
          : widget.til.icons.icon.focusTint
          : widget.til.icons.icon.tint == null
          ? SfwColors.edtIconNormal == null
          ? tilNormalColor
          : SfwColors.edtIconNormal
          : widget.til.icons.icon.tint;
      _iconRightMargin = _iconRightPadding;

      row.add(
//        Expanded(
//          flex: 1,
//          child:
        Padding(
          padding: EdgeInsets.only(
            right: SfwHelper.setWidth(_iconRightPadding),
            left: SfwHelper.setWidth(_iconLeftPadding),
            // bottom: SfwHelper.setHeight(_iconBottomPadding==0?padding.bottom:_iconBottomPadding),
            // top: SfwHelper.setHeight(_iconTopPadding),
          ),
          child: widget.til.icons.icon.widget != null
              ? widget.til.icons.icon.widget
              : Container(
            alignment: FractionalOffset.centerLeft,
            width: SfwHelper.pxToDp(_iconSize),
            child: widget.til.icons.icon.onPressed == null
                ? Icon(
              widget.til.icons.icon.icon,
              size: SfwHelper.pxToDp(_iconSize),
              color: iconColor,
            )
                : SfwUiHelper.circleWidget(
                Icon(
                  widget.til.icons.icon.icon,
                  size: SfwHelper.pxToDp(_iconSize),
                  color: iconColor,
                ),
                SfwHelper.pxToDp((_iconSize) + 20),
                widget.til.icons.icon.onPressed),
          ),
        ),
//        ),
      );
    }

    stackChildren.add(
      Container(
//        width: widget.til.isWHpercentage != null && !widget.til.isWHpercentage
//            ? widget.til.width
//            : null,
//        height: widget.til.isWHpercentage != null && !widget.til.isWHpercentage
//            ? widget.til.height
//            : null,
        margin: EdgeInsets.only(
            left: SfwHelper.setWidth(
                _iconRightMargin == null || _iconRightMargin < 0
                    ? 0
                    : _iconRightMargin)),
        child: SfwUiHelper.til(
          til: SfwTil(
            textsRelated: widget.til.textsRelated,
            styles: widget.til.styles,
            texts: controller != null
                ? SfwTilText(
                labelText: widget.til.texts.labelText,
                helperText: widget.til.texts.helperText,
                hintText: widget.til.texts.hintText,
                errorText: widget.til.texts.errorText,
                text: null,
                counterText: widget.til.texts.counterText,
                suffixText: widget.til.texts.suffixText,
                prefixText: widget.til.texts.prefixText,
                semanticCounterText: widget.til.texts.semanticCounterText)
                : widget.til.texts,
            decoration: SfwTilDecoration(
              outlineBorderRadius: widget.til.decoration.outlineBorderRadius,
              underlineBorderRadius:
              widget.til.decoration.underlineBorderRadius,
              border: widget.til.decoration.border,
              disabledBorder: widget.til.decoration.disabledBorder,
              disabledBorderColor: widget.til.decoration.disabledBorderColor,
              enabledBorder: widget.til.decoration.enabledBorder,
              enabledBorderColor: widget.til.decoration.enabledBorderColor,
              errorBorder: widget.til.decoration.errorBorder,
              errorBorderColor: widget.til.decoration.errorBorderColor,
              fillColor: widget.til.decoration.fillColor,
              focusColor: widget.til.decoration.focusColor,
              focusedBorder: widget.til.decoration.focusedBorder,
              focusedBorderColor: widget.til.decoration.focusedBorderColor,
              focusedErrorBorder: widget.til.decoration.focusedErrorBorder,
              focusedErrorBorderColor:
              widget.til.decoration.focusedErrorBorderColor,
              hoverColor: widget.til.decoration.hoverColor,
              normalBorderColor: widget.til.decoration.normalBorderColor,
              scrollPadding: widget.til.decoration.scrollPadding,
              contentPadding: padding,
            ),
            booleans: widget.til.booleans,
            actions: widget.til.actions
                .copyWith(focusNode: _focusNode, controller: controller),
            textProperty: widget.til.textProperty,
            icons: SfwTilIcons(counter: widget.til.icons.counter),
          ),
        ),
      ),
    );
    if (widget.til.icons.prefixIcon.icon != null ||
        widget.til.icons.prefixIcon.widget != null) {
      Color iconColor = _focusNode.hasFocus
          ? widget.til.icons.prefixIcon.focusTint == null
          ? SfwColors.edtIconPrefixFocused == null
          ? tilFocusedColor
          : SfwColors.edtIconPrefixFocused
          : widget.til.icons.prefixIcon.focusTint
          : widget.til.icons.prefixIcon.tint == null
          ? SfwColors.edtIconPrefixNormal
          : widget.til.icons.prefixIcon.tint;
      stackChildren.add(
        Container(
          alignment: isTextEmpty
              ? FractionalOffset.centerLeft
              : FractionalOffset.centerLeft,
//          margin: EdgeInsets.only(
//            left: SfwHelper.setWidth(_iconRightMargin),
//          ),
          width: SfwHelper.pxToDp(_prefixIconSize),
          child: Padding(
              padding: EdgeInsets.only(
                right: SfwHelper.setWidth(_prefixIconRightPadding),
                left: SfwHelper.setWidth(_prefixIconLeftPadding),
                bottom: SfwHelper.setHeight(_prefixIconBottomPadding),
                top: SfwHelper.setHeight(_prefixIconTopPadding),
              ),
              child: widget.til.icons.prefixIcon.widget != null
                  ? widget.til.icons.prefixIcon.widget
                  : widget.til.icons.prefixIcon.onPressed == null
                  ? Icon(
                widget.til.icons.prefixIcon.icon,
                size: SfwHelper.pxToDp(_prefixIconSize),
                color: iconColor,
              )
                  : SfwUiHelper.circleWidget(
                  Icon(
                    widget.til.icons.prefixIcon.icon,
                    size: SfwHelper.pxToDp(_prefixIconSize),
                    color: iconColor,
                  ),
                  SfwHelper.pxToDp(_prefixIconSize + 20),
                  widget.til.icons.prefixIcon.onPressed)),
        ),
      );
    }
    if (widget.til.icons.suffixIcon.icon != null ||
        widget.til.icons.suffixIcon.widget != null) {
      Color iconColor = _focusNode.hasFocus
          ? widget.til.icons.suffixIcon.focusTint != null
          ? widget.til.icons.suffixIcon.focusTint
          : SfwColors.edtIconSuffixFocused == null
          ? tilFocusedColor
          : SfwColors.edtIconSuffixFocused
          : widget.til.icons.suffixIcon.tint != null
          ? widget.til.icons.suffixIcon.tint
          : SfwColors.edtIconSuffixNormal;
      stackChildren.add(
        Padding(
          padding: EdgeInsets.only(
            right: SfwHelper.setWidth(_suffixIconRightPadding),
            left: SfwHelper.setWidth(_suffixIconLeftPadding),
            bottom: SfwHelper.setHeight(_suffixIconBottomPadding),
            top: SfwHelper.setHeight(_suffixIconTopPadding),
          ),
          child: Align(
            alignment: FractionalOffset.centerRight,
            child: widget.til.icons.suffixIcon.widget != null
                ? widget.til.icons.suffixIcon.widget
                : widget.til.icons.suffixIcon.onPressed != null
                ? SfwUiHelper.circleWidget(
                Icon(
                  widget.til.icons.suffixIcon.icon,
                  color: iconColor,
                  size: SfwHelper.pxToDp(_suffixIconSize),
                ),
                SfwHelper.pxToDp(_suffixIconSize + 20),
                widget.til.icons.suffixIcon.onPressed)
                : Icon(
              widget.til.icons.suffixIcon.icon,
              color: iconColor,
              size: SfwHelper.pxToDp(_suffixIconSize),
            ),
          ),
        ),
      );
    }
    row.add(Expanded(
//        flex: 8,
        child: Stack(
          alignment: isTextEmpty && !_focusNode.hasFocus
              ? FractionalOffset.centerLeft
              : FractionalOffset.centerLeft,
          children: stackChildren,
        )));

    Widget finalWidget = Row(
      mainAxisSize: MainAxisSize.max,
      children: row,
    );
    if ((widget.til.isWHpercentage == null || !widget.til.isWHpercentage) &&
        (widget.til.height != null || widget.til.width != null)) {
      if (widget.til.height != null && widget.til.width != null) {
        finalWidget = SizedBox(
          width: widget.til.width,
          height: widget.til.height,
          child: finalWidget,
        );
      } else if (widget.til.height == null && widget.til.width != null) {
        finalWidget = SizedBox(
          width: widget.til.width,
          child: finalWidget,
        );
      } else if (widget.til.height != null && widget.til.width == null) {
        finalWidget = SizedBox(
          height: widget.til.height,
          child: finalWidget,
        );
      }
    }
    if (widget.til.alignment != null &&
        widget.til.isWHpercentage != null &&
        widget.til.isWHpercentage) {
      finalWidget = FractionallySizedBox(
        alignment: widget.til.alignment,
        child: finalWidget,
        heightFactor: widget.til.height,
        widthFactor: widget.til.width,
      );
    } else if (widget.til.alignment != null) {
      finalWidget = Align(
        alignment: widget.til.alignment,
        child: finalWidget,
      );
    }

    return finalWidget;
  }
}

class SfwCheckBox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final Color normalColor;
  final Color checkedColor;
  final MaterialTapTargetSize materialTapTargetSize;
  final IconData checkedIcon;
  final IconData normalIcon;
  final Widget text;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double iconSize;
  final double paddingWithText;
  final double width;
  final double height;
  final bool isRadio;
  final int id;

//  /// You can use this in a group of checkboxes
//  /// step 1:  create a bloc object
//  /// step 2:  pass the same bloc object in all checkboxes
//  /// step 3:  pass a unique id to all checkbox
//  /// step 4:  set isForUniqueGroup = true
//  ///
//  /// Also you can use the bloc object to change the text and checked status value  -> Note : Don't use same bloc object to change the status and text
//  final SfwCheckboxBloc bloc;

  const SfwCheckBox(
      {Key key,
        this.alignment,
        this.width,
        this.height,
        this.padding,
        this.margin,
        this.iconSize,
        this.isChecked = false,
        @required this.onChanged,
        this.normalColor,
        this.checkedColor,
        this.materialTapTargetSize,
        this.checkedIcon,
        this.normalIcon,
        this.text,
        this.paddingWithText,
        this.isRadio = false,
        this.id})
      : assert(isChecked != null),
        assert(isRadio != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    IconData cIcon = this.checkedIcon == null
        ? this.isRadio ? Icons.check_circle : Icons.check_box
        : this.checkedIcon;
    IconData nIcon = this.normalIcon == null
        ? this.isRadio
        ? Icons.check_circle_outline
        : Icons.check_box_outline_blank
        : this.normalIcon;

    return _SfwCheckBoxState(
        this.isChecked != null && this.isChecked, cIcon, nIcon);
  }
}

class _SfwCheckBoxState extends State<SfwCheckBox> {
  bool _isChecked = false;
  final IconData checkedIcon;
  final IconData normalIcon;

  _SfwCheckBoxState(this._isChecked, this.checkedIcon, this.normalIcon);

  @override
  void didUpdateWidget(SfwCheckBox oldWidget) {
    _isChecked = widget.isRadio ? widget.isChecked : _isChecked;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor:
      widget.checkedColor ?? widget.normalColor ?? SfwColors.primaryColor,
      onTap: () {
//        if (widget.isRadio && _isChecked) {
//          return;
//        }
        setState(() {
          _isChecked = !_isChecked;
          if (widget.onChanged != null) {
            widget.onChanged(_isChecked);
          }
        });
      },
      child: Container(
        width: widget.width,
        color: Colors.transparent,
        height: widget.height,
        alignment: widget.alignment ?? FractionalOffset.centerLeft,
        padding: widget.padding,
        margin: widget.margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              _isChecked ? checkedIcon : normalIcon,
              color: _isChecked
                  ? widget.checkedColor ?? SfwColors.cbTintChecked
                  : widget.normalColor ?? SfwColors.cbTintNormal,
              size:
              SfwHelper.pxToDp(widget.iconSize ?? SfwConstants.cbIconSize),
            ),
            widget.text == null
                ? Text("")
                : Padding(
              padding: EdgeInsets.only(
                  left: SfwHelper.setWidth(widget.paddingWithText ??
                      SfwConstants.cbTextLeftMargin)),
              child: widget.text,
            )
          ],
        ),
      ),
    );
  }
}

class AppUi {
  static Widget clickableTil(SfwTextInput input, VoidCallback onTap) {
    return InkWell(
      child: input,
      onTap: onTap,
    );
  }

  static pickDate(
      BuildContext context, String selectedDate, Function(DateTime) onConfirm) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        onConfirm: onConfirm,
        currentTime: SfwHelper.parse(SfwStrings.WEB_DATE_FORMAT, selectedDate,
            defDateTime: DateTime.now()),
        locale: LocaleType.en);
  }

  static showDropDown(BuildContext context, Widget child, List<String> list,
      Function(int, String) onSelected) {
    List<PopupMenuEntry<int>> menu = [];
    for (int i = 0; i < list.length; ++i)
      menu.add(PopupMenuItem(
        child: SfwUiHelper.commonText(
          list[i],
        ),
        value: i,
      ));
    return PopupMenuButton(
      itemBuilder: (context) {
        return menu;
      },
      child: child,
      onCanceled: () {
        SfwHelper.hideKeyboard(context);
      },
      onSelected: (val) {
        SfwHelper.hideKeyboard(context);
        if (onSelected != null) onSelected(val, list[val]);
      },
    );
  }

  static SfwTextInput input(String text, String label, Function(String) onSaved,
      {TextInputType inputType = TextInputType.text,
        TextInputAction inputAction: TextInputAction.next,
        int maxLines,
        int minLines,
        int maxLength,
        int minLength,
        String error,
        bool isEnabled = true,
        bool isOutline = true,
        TextEditingController controller,
        FocusNode focusNode,
        SfwTilIcons icons = const SfwTilIcons()}) {
    return SfwTextInput(
      til: SfwTil(
          texts: SfwTilText(
            labelText: label,
            text: text,
            errorText: error,
          ),
          icons: icons,
          actions: SfwTilActions(
            onSaved: onSaved,
            controller: controller,
            focusNode: focusNode,
          ),
          booleans: SfwTilBool(
            isOutline: isOutline,
            enabled: isEnabled,
          ),
          textProperty: SfwTilTextProperty(
            inputType: inputType,
            inputAction: inputAction,
          ),
          textsRelated: SfwTilTextsRelated(
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            minLength: minLength,
          )),
    );
  }
}
