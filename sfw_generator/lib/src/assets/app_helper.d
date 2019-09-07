typedef SfwNotifierBuilder=Widget Function(String key, dynamic data);

abstract class SfwNotifierListener {
  void onSfwNotifierCalled(String key, dynamic data);
}

class SfwNotifier {
  final Map<SfwNotifierListener, Set<String>> _listeners = {};
  static SfwNotifier _notifier = SfwNotifier();

  //Map<SfwNotifierListener,Set<String>> get listener=>_listeners;

  static addListener(SfwNotifierListener listener, Set<String> keys) {
    if (listener == null)
      return;
    Set<String> list = _notifier._listeners[listener];
    if (list == null) {
      list = {};
    }
    if (keys != null)
      list.addAll(keys);
    _notifier._listeners[listener] = list;
  }

  static removeListener(SfwNotifierListener listener) {
    if (listener == null)
      return;
    _notifier._listeners.remove(listener);
  }

  static notify(String key, dynamic value) {
    _notifier._listeners.forEach((listener, _keys) {
      if (listener != null && _keys.isEmpty || _keys.contains(key)) {
        listener.onSfwNotifierCalled(key, value);
      }
    });
  }
}

class SfwNotifierForSingleKey {
  final Map<String, Set<SfwNotifierListener>> _listeners = {};
  static SfwNotifierForSingleKey _notifier = SfwNotifierForSingleKey();

  static addListener(SfwNotifierListener listener, String key) {
    if (listener == null || key == null || key
        .trim()
        .isEmpty)
      return;
    Set<SfwNotifierListener> list = _notifier._listeners[key];
    if (list == null) {
      list = {};
    }
    list.add(listener);
    _notifier._listeners[key] = list;
  }

  static removeListener(SfwNotifierListener listener, String key) {
    if (listener == null || key == null || key
        .trim()
        .isEmpty)
      return;
    Set<SfwNotifierListener> list = _notifier._listeners[key];
    if (list == null) {
      return;
    }
    list.remove(listener);
    if (list.isEmpty) {
      _notifier._listeners.remove(key);
    } else {
      _notifier._listeners[key] = list;
    }
  }

  static notify(String key, dynamic value) {
    if (key == null || key
        .trim()
        .isEmpty)
      return
        _notifier._listeners[key].forEach((listener) {
          if (listener != null)
            listener.onSfwNotifierCalled(key, value);
        });
  }
}


class SfwNotifierSingleKeyWidget extends StatefulWidget {
  final SfwNotifierBuilder builder;
  final String notifierKey;
  final dynamic initialData;

  const SfwNotifierSingleKeyWidget(
      {Key key, @required this.builder, @required this.notifierKey, this.initialData})
      : assert(builder != null),
        assert(notifierKey != null && notifierKey != ""),
        super(key: key);

  @override
  _SfwNotifierWidgetState createState() => _SfwNotifierWidgetState();
}

class _SfwNotifierWidgetState extends State<SfwNotifierSingleKeyWidget>
    implements SfwNotifierListener {

  dynamic data;

  @override
  void initState() {
    data = widget.initialData;
    SfwNotifierForSingleKey.addListener(this, widget.notifierKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.notifierKey, data);
  }

  @override
  void onSfwNotifierCalled(String key, data) {
    setState(() {
      this.data = data;
    });
  }

  @override
  void dispose() {
    SfwNotifierForSingleKey.removeListener(this, widget.notifierKey);
    super.dispose();
  }


}

class SfwNotifierMultiKeyWidget extends StatefulWidget {
  final SfwNotifierBuilder builder;
  final Set<String> notifierKeys;
  final dynamic initialData;
  final String initialKey;

  const SfwNotifierMultiKeyWidget(
      {Key key, @required this.builder, @required this.notifierKeys, this.initialData, this.initialKey})
      : assert(builder != null),
        assert(notifierKeys != null),
        super(key: key);

  @override
  _SfwNotifierMultiKeyWidgetState createState() =>
      _SfwNotifierMultiKeyWidgetState();
}

class _SfwNotifierMultiKeyWidgetState extends State<SfwNotifierMultiKeyWidget>
    implements SfwNotifierListener {

  dynamic data;
  String key;

  @override
  void initState() {
    data = widget.initialData;
    SfwNotifier.addListener(this, widget.notifierKeys);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(key, data);
  }

  @override
  void onSfwNotifierCalled(String key, data) {
    setState(() {
      this.key = key;
      this.data = data;
    });
  }

  @override
  void dispose() {
    SfwNotifier.removeListener(this);
    super.dispose();
  }


}


class SfwHelper {
  static ScreenUtil util;
  static double screenWidth;
  static double screenWidthPx;
  static double screenHeight;
  static double screenHeightPx;
  static const String yyyy_MM_dd_HH_mm_ss_S_Z = "yyyy-MM-dd HH:mm:ss.SZ";
  static const String MM_dd_yyyy_KK_mm_ss__a = "MM-dd-yyyy KK:mm:ss a";
  static const String MM_dd_yyyy_KK_mm_ss_a = "MM-dd-yyyy KK:mm:ssa";

  static initialize(BuildContext context,{double width = 1080,
    double  height = 1920,
    bool allowFontScaling = false}) {
    if (util == null || util.scaleWidth < 1) {
      util = ScreenUtil(width: width,height: height,allowFontScaling: allowFontScaling);
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

  static String convertDate(String fromFormat, String toFormat, String date) {
    try {
      return DateFormat(toFormat).format(DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertDateTime(String toFormat, DateTime date) {
    try {
      return DateFormat(toFormat).format(date);
    } on FormatException {
      return "";
    }
  }

  static String convertWebToLocalDate(String toFormat, String date,
      {String fromFormat = "yyyy-MM-dd HH:mm:ss"}) {
    try {
      return DateFormat(toFormat).format(DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertUtcToLocalDate(String fromFormat, String toFormat,
      String date) {
    try {
      return DateFormat(toFormat).format(DateFormat(fromFormat).parse(date));
    } on FormatException {
      return "";
    }
  }

  static String convertLocalToUtcDate(String fromFormat, String toFormat,
      String date) {
    try {
      return DateFormat(toFormat).format(DateFormat(fromFormat).parse(date));
    } catch (e) {
      print(e);
      return "";
    }
  }

  static String convertLocalToWebDate(String fromFormat, String date,
      {String toFormat = "yyyy-MM-dd HH:mm:ss"}) {
    return convertLocalToUtcDate(fromFormat, toFormat, date);
  }

  static bool isDateAfter(String format, String date, String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAfter(
          DateFormat(format).parse(dateToCompare));
    } catch (e) {
      return false;
    }
  }

  static bool isDateBefore(String format, String date, String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isBefore(
          DateFormat(format).parse(dateToCompare));
    } catch (e) {
      return false;
    }
  }

  static bool isEqual(String format, String date, String dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAtSameMomentAs(
          DateFormat(format).parse(dateToCompare));
    } catch (e) {
      return false;
    }
  }

  static bool isDateAfterDateTime(String format, String date,
      DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAfter(dateToCompare);
    } catch (e) {
      return false;
    }
  }

  static bool isDateBeforeDateTime(String format, String date,
      DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isBefore(dateToCompare);
    } catch (e) {
      return false;
    }
  }

  static bool isEqualDateTime(String format, String date,
      DateTime dateToCompare) {
    try {
      return DateFormat(format).parse(date).isAtSameMomentAs(dateToCompare);
    } catch (e) {
      return false;
    }
  }

  static DateTime parse(String format, String date,
      {DateTime defDateTime, bool isUtc = false}) {
    try {
      return DateFormat(format).parse(date);
    } catch (e) {
      return defDateTime ?? null;
    }
  }


  static void hideKeyboard(BuildContext ctx) {
    try {
      FocusScope.of(ctx).requestFocus(FocusNode());
      // SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (e) {}
  }

  static String extension(String fileUrl) {
    return fileUrl == null || !fileUrl.contains(".") ? "" : fileUrl.substring(
        fileUrl.indexOf(".") + 1);;
  }

  static bool isDocument(fileUrl) {
    String ext = extension(fileUrl).toLowerCase();
    return ext != "" &&
        (ext == 'pdf' || ext == 'doc' || ext == 'txt' || ext == 'docx' ||
            ext == 'ppt' || ext == 'pptx' || ext == 'xls' || ext == 'xlsx');
  }

  static bool isImage(fileUrl) {
    String ext = extension(fileUrl).toLowerCase();
    return ext != "" && (ext == 'jpg' || ext == 'jpeg' || ext == 'png');
  }


}
