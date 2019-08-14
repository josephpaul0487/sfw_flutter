class SfwWebResponseType {
  static const String STREAM = "stream";
  static const String JSON = "json";
  static const String BYTES = "bytes";
  static const String PLAIN = "plain";
}

class SfwWebContentType {
  static const String TEXT = "text";
  static const String JSON = "json";
  static const String HTML = "html";
  static const String BINARY = "binary";
}

class SfwWebCallType {
  static const String GET = "get";
  static const String POST = "post";
  static const String PUT = "put";
  static const String DELETE = "delete";
}

class SfwWebConfig {
  final String baseUrl;
  final bool debug;
  final String contentType;
  final String responseType;
  final Map<String, String> header;

  const SfwWebConfig(this.baseUrl,
      {this.debug = false,
      this.contentType = SfwWebContentType.JSON,
      this.responseType = SfwWebResponseType.JSON,
      this.header = const {}})
      : assert(baseUrl != null &&
            baseUrl != "" &&
            debug != null &&
            contentType != null &&
            responseType != null &&
            header != null);
}

class SfwWebCall {
  final String url;
  final bool useBaseUrl;

  ///Should implement StatusInterface || DataListInterface  ||  DataInterface
  final Type responseClassType;
  final Type responseGenericType;
  final List<int> responseSuccessCodes;
  final bool deletePreviousData;
  final String dbTable;
  final bool setDataAsNormalParameter;
  final bool setDataAsNamedParameter;
  final Map<String, dynamic> header;
  final List<String> dataKeys;
  final String contentType;
  final String responseType;
  final bool isMultiPart;
  final int connectTimeout;
  final int receiveTimeout;

  const SfwWebCall(this.url, this.responseClassType,
      {this.responseGenericType,
      this.useBaseUrl = true,
      this.responseType = SfwWebResponseType.JSON,
      this.contentType = SfwWebContentType.JSON,
      this.responseSuccessCodes = const [200],
      this.deletePreviousData = false,
      this.dbTable,
      this.setDataAsNormalParameter = true,
      this.setDataAsNamedParameter = false,
      this.isMultiPart = false,
      this.header = const {},
      this.dataKeys = const [],
      this.connectTimeout,
      this.receiveTimeout})
      : assert(url != null &&
            responseClassType != null &&
            useBaseUrl != null &&
            responseType != null &&
            contentType != null &&
            setDataAsNamedParameter != null &&
            setDataAsNormalParameter != null &&
            isMultiPart != null &&
            header != null &&
            dataKeys != null); //,
//        assert(
//            responseClassType is StatusInterface ||
//                ((responseClassType is DataListInterface ||
//                        responseClassType is DataInterface) &&
//                    responseGenericType != null),
//            "$responseClassType should implement StatusInterface | DataListInterface | DataInterface. To use DataListInterface | DataInterface the responseGenericType should not be null ");
}
