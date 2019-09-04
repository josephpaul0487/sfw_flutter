
abstract class SfwState <T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    try {
      if(mounted)
        super.setState(fn==null?(){}:fn);
    } catch(e) {
      print(e);
    }
  }

  bool toastMessage(bool showToast,String toastMessage) {
    if(showToast && (toastMessage!=null && toastMessage.isNotEmpty))
      SfwUi.showToast(toastMessage);
    return showToast;
  }

  bool isEmpty(String str,[String toastMessage]}) {
    return this.toastMessage(str==null || str.trim().isEmpty ,toastMessage);
  }


}