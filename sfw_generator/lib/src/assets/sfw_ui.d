class SfwUi {
  static bool hasPermission(PermissionGroup permission,
      [String toastMessage]) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(permission);
    if (permission == null || permission != PermissionStatus.granted) {
      Map<PermissionGroup,
          PermissionStatus> permissions = await PermissionHandler()
          .requestPermissions([permission]);
      if (permissions == null || permissions.length == 0 ||
          !permissions.containsKey(permission) ||
          permissions[permission] != PermissionStatus.granted) {
        if (toastMessage != null && toastMessage.isNotEmpty)
          WidgetHelper.showToast(toastMessage);
        return false;
      }
    }
    return true;
  }

  static bool hasPermissions(List<PermissionGroup> permissions,
      [List<String> toastMessages]) async {
    bool isToastEmpty=toastMessages==null || toastMessages.isEmpty;
    if(!isToastEmpty && permissions.length!=toastMessages.length) {
      throw Exception("Either toastMessages is empty or toastMessages.length == permissions.length");
    }

    for(int i=0;i<permissions.length;++i) {
      if(!await hasPermission(permissions[i],isToastEmpty?null:toastMessages[i])) {
        return false;
      }
    }
    return true;
  }

  static void showToast(String msg,) {
    try {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: SfwHelper.setSp(30.0));
    } catch (e) {}
  }
}