import 'package:flutter_openshare_example/services/http_response.dart';

class HttpProcess<T> {
  bool loading;
  HttpServiceResponse<T> response;

  HttpProcess({this.loading, this.response});
}