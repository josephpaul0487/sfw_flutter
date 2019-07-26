



mixin StatusInterface {
  bool isSuccess();
  String getMessage();
  Object getTag();
  setMessage(String msg);
  setTag(Object tag);
  setAsNetworkError(bool isNetworkError);
}
mixin DataInterface<T> implements StatusInterface {
  T getData();
  setData(T data);
}

mixin DataListInterface<T> implements StatusInterface {
  List<T> getData();
  setData(List<T> data);
}


mixin HelperMethods {
  String avoidNull(String str) {
    return str==null ? "" : str;
  }
}

class StatusModel with HelperMethods implements StatusInterface  {
  int status;
  int tagCode;
  String msg;
  bool isNetworkError;

  StatusModel({this.status=0, this.tagCode=0, this.msg="",this.isNetworkError=false});

  @override
  bool isSuccess() {
    return this.status==1;
  }

  @override
  String getMessage() {
    return avoidNull(msg);
  }

  @override
  setMessage(String msg) {
    this.msg=msg;
  }

  Object getTag() {
    return tagCode;
  }

  @override
  setTag(Object tag) {
    this.tagCode=tag;
  }

  @override
  setAsNetworkError(bool isNetworkError) {
    this.isNetworkError=isNetworkError;
  }

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
      status: json['status'] as int,
      tagCode: json['tagCode'] as int,
      msg: json['msg'] as String);


}

class CommonModel<T> extends StatusModel implements DataInterface {
  T data;

  CommonModel({this.data, int status, int tagCode, String msg,bool isNetworkError=false}):super(status:status,tagCode:tagCode,msg:msg,isNetworkError:isNetworkError);

  factory CommonModel.fromJson(Map<String, dynamic> json) => CommonModel<T>(
      status: json['status'] as int,
      tagCode: json['tagCode'] as int,
      msg: json['msg'] as String);

  @override
  getData() {
    return data;
  }

  @override
  setData(data) {
    this.data=data;
  }
}

class CommonModelList<T> extends StatusModel implements DataListInterface {
  List<T> data;

  CommonModelList({this.data, int status, int tagCode, String msg,bool isNetworkError=false}):super(status:status,tagCode:tagCode,msg:msg,isNetworkError:isNetworkError);

  factory CommonModelList.fromJson(Map<String, dynamic> json) => CommonModelList<T>(
      status: json['status'] as int,
      tagCode: json['tagCode'] as int,
      msg: json['msg'] as String);

  @override
  List getData() {
    return data;
  }

  @override
  setData(List data) {
    this.data=data;
  }
}