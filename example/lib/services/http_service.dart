import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_openshare_example/app_config.dart';
// import 'package:device_info/device_info.dart';
import 'package:flutter_openshare_example/services/http_response.dart';
// import 'package:mmkv_flutter/mmkv_flutter.dart';
// import 'package:meiying/utils/app_config.dart';

class HttpService {
  //SharedPreferences prefs;
  // MmkvFlutter mmkv;
  List<String> _systemInfo;
  //Map<String, dynamic> _headers;
  Dio _dio;
  BaseOptions options;
  //bool _headerFlag=false;
  //bool _tokenFlag=false;
  //Options _baseOptions;
  HttpService() {
    this.options = new BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
      // contentType: ContentType.parse("application/x-www-form-urlencoded"),
      //data: HttpServiceResponse
    );
    _dio = new Dio(this.options);
    _dio.interceptors.add(InterceptorsWrapper(onError: (DioError err) async {
      //_dio.interceptor.response.lock();
      // print(err.message);
      var res = AppConfig.httpServiceError[err.type.index];
      //_dio.interceptor.response.unlock();
      return new HttpServiceResponse(
          msg: res["msg"], data: null, ret: res["ret"]);
    }, onResponse: (Response ret) async {
      try {
        var result = HttpServiceResponse.fromJson(ret.data);
        if (result.data != false) {
          return result;
        } else {
          var res = AppConfig.httpServiceError[2];
          return new HttpServiceResponse(
              msg: res["msg"], data: null, ret: res["ret"]);
        }
      }  catch (err) {
        var res = AppConfig.httpServiceError[2];
        return new HttpServiceResponse(
            msg: res["msg"], data: null, ret: res["ret"]);
      }
    }));

  }
  Future<Response<T>> get<T>(
    String path, {
    Map<String,dynamic> data,
    CancelToken cancelToken,
    Options options,
  }) async {
    var ops = await _getOptions();
    _dio.options.headers = ops.headers;
    return _dio.get<T>(path,
        queryParameters: data, cancelToken: cancelToken, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    data,
    CancelToken cancelToken,
    Options options,
  }) async {
    var ops = await _getOptions();
    _dio.options.headers = ops.headers;
    return _dio.post<T>(path,
        data: data, cancelToken: cancelToken, options: options);
  }

  Future<Response<T>> request<T>(
    String path, {
    data,
    CancelToken cancelToken,
    Options options,
  }) async {
    var ops = await _getOptions();
    _dio.options.headers = ops.headers;
    return _dio.request<T>(path,
        data: data, cancelToken: cancelToken, options: options);
  }

  Future<Options> _getOptions() async {

    var _baseOptions = new Options();
    _baseOptions.headers["appId"] = AppConfig.appId;

    bool isAndroid = Platform.isAndroid;
    // if (mmkv == null) {
    //   mmkv = await MmkvFlutter.getInstance();
    // }
    // var token = await mmkv.getString("MY_APP_TOKEN");
    // if (token != "") {
    //   _baseOptions.headers['api-token'] = token;
    // }
    // var info = await mmkv.getString("MY_APP_SYSTEMINFO");
    // if (info != "") {
    //   _systemInfo = info.split("@");
    // }

    // if (_systemInfo == null) {
    //   _systemInfo = new List<String>();
    //   DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    //   var deviceResult;
    //   if (isAndroid) {
    //     deviceResult = await deviceInfo.androidInfo;
    //     _systemInfo.add(deviceResult.model);
    //     _systemInfo.add(deviceResult.brand);
    //     _systemInfo.add(deviceResult.version.release);
    //     _systemInfo.add(deviceResult.id);
    //   } else {
    //     deviceResult = await deviceInfo.iosInfo;
    //     _systemInfo.add(deviceResult.utsname.machine);
    //     _systemInfo.add(deviceResult.model);
    //     _systemInfo.add(deviceResult.systemVersion);
    //     _systemInfo.add(deviceResult.identifierForVendor);
    //   }
    //   await mmkv.setString("MY_APP_SYSTEMINFO", _systemInfo.join("@"));
    //   deviceResult = null;
    //   deviceInfo = null;
    // }
    _baseOptions.headers['App-isandroid'] = isAndroid ? 1 : 0;
    // _baseOptions.headers['App-system-model'] = _systemInfo[0];
    // _baseOptions.headers['App-system-brand'] = _systemInfo[1];
    // _baseOptions.headers['App-system-version'] = _systemInfo[2];
    // _baseOptions.headers['App-system-deviceid'] = _systemInfo[3];
    return _baseOptions;
  }
}
