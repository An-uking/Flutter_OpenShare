class HttpServiceResponse<T> {
  T data;
  int ret;
  String msg;
  HttpServiceResponse({this.data, this.ret, this.msg});
  HttpServiceResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        msg = json['msg'],
        ret = json['ret'];
}