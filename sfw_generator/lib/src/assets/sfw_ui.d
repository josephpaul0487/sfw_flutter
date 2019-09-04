class SfwUi {
  static Future<bool> hasPermission(PermissionGroup permission,
      [String toastMessage]) async {

    try {
      PermissionStatus hasPermission =
      await PermissionHandler().checkPermissionStatus(permission);
      if (hasPermission == null || hasPermission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([permission]);
        if (permissions == null ||
            permissions.length == 0 ||
            !permissions.containsKey(permission) ||
            permissions[permission] != PermissionStatus.granted) {
          if (toastMessage != null && toastMessage.isNotEmpty)
            SfwUi.showToast(toastMessage);
          return false;
        }
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static Future<bool> hasPermissions(List<PermissionGroup> permissions,
      [List<String> toastMessages]) async {
    if(permissions==null)
      return false;
    if(permissions.isEmpty)
      return true;
    bool isToastEmpty = toastMessages == null || toastMessages.isEmpty;
    if (!isToastEmpty && permissions.length != toastMessages.length) {
      throw Exception(
          "Either toastMessages is empty or toastMessages.length == permissions.length");
    }

    for (int i = 0; i < permissions.length; ++i) {
      if (!await hasPermission(
          permissions[i], isToastEmpty ? null : toastMessages[i])) {
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