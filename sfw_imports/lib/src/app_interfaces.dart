

typedef OnClickCallback = void Function();
typedef OnClickCallbackWithTag = void Function(Object tag);
typedef OnClickCallbackWithTag2 = bool Function(Object tag);
typedef OnClickCallback2 = bool Function();

class OnClickListener {
  bool clicked = false;
  final Object tag;
  final Function() listener;
  final OnClickCallbackWithTag listenerWithTag;

  OnClickListener({this.listener,this.listenerWithTag,this.tag});

  void onClick() {
    if (clicked) return;
    clicked = true;
    if (this.listener != null) this.listener();
    if (this.listenerWithTag != null) this.listenerWithTag(tag);
    clicked = false;
  }
}

class OnClickListener2 {
  bool clicked = false;
  final Object tag;
  final OnClickCallback2 listener;
  final OnClickCallbackWithTag2 listenerWithTag;

  OnClickListener2({this.listener,this.listenerWithTag,this.tag});

  void onClick() {
    if (clicked) return;
    clicked = true;
    if (this.listener != null) this.listener();
    if (this.listenerWithTag != null) this.listenerWithTag(tag);
    clicked = false;
  }
}

typedef BoolCallBack = bool Function();


