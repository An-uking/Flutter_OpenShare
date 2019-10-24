import 'dart:async';

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';

typedef void InstallMessageHandler(OSInstall params);
typedef void WakeUpMessageHandler(OSWakeUp params);

class FlutterOpenshare {
  static FlutterOpenshare _instance;
  factory FlutterOpenshare() {
    if (_instance == null) {
      _instance = new FlutterOpenshare.private(
          const MethodChannel('openshare.cc/Flutter_OpenShare'));
    }
    return _instance;
  }
  FlutterOpenshare.private(MethodChannel channel) : _channel = channel;

  InstallMessageHandler _onInstallMessage;
  WakeUpMessageHandler _onWakeUpMessage;
  final MethodChannel _channel;
  void addEventHandler({
    InstallMessageHandler onInstallMessage,
    WakeUpMessageHandler onWakeUpMessage,
  }) {
    _onInstallMessage = onInstallMessage;
    _onWakeUpMessage = onWakeUpMessage;
    _channel.setMethodCallHandler(_handleMethod);
    _setup();
  }

  Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "install":
        _onInstallMessage(OSInstall.fromJson(call.arguments));
        break;
      case "wakeup":
        // print(call.arguments);
        _onWakeUpMessage(OSWakeUp.fromJson(call.arguments));
        break;
    }
  }

  Future<void> _setup() async {
    await _channel.invokeMethod('setup');
  }

  Future<OSInstall> getInstallParams() async {
    final dynamic result = await _channel.invokeMethod('getInstallParams');
    return OSInstall.fromJson(result);
  }

  Future<OSWakeUp> getWakeUpParams() async {
    final dynamic result = await _channel.invokeMethod('getWakeUpParams');
    return OSWakeUp.fromJson(result);
  }
  Future<String> getUUID() async {
    final String result = await _channel.invokeMethod('getUUID');
    return result;
  }
}

class OSInstallData {
  String channelCode;
  String value;
  OSInstallData({this.channelCode,this.value});
  OSInstallData.fromJson(Map<dynamic, dynamic> json)
      : value = json['value'],
        channelCode=json['channelCode'];
}

class OSInstall {
  int ret;
  String msg;
  OSInstallData data;
  OSInstall({this.ret, this.msg, this.data});
  OSInstall.fromJson(Map<dynamic, dynamic> json)
      : ret = int.tryParse(json['ret'].toString()),
        msg = json['msg'],
        data = json['data']!=null ? OSInstallData.fromJson(json['data']) : null;
}

class OSWakeUpData {
  String val;
  String path;
  OSWakeUpData({this.val,this.path});
  OSWakeUpData.fromJson(Map<dynamic, dynamic> json)
      : val = json['val'],
        path = json['path'];
}

class OSWakeUp {
  int ret;
  String msg;
  // bool type;
  OSWakeUpData data;
  OSWakeUp({this.ret, this.msg, this.data});
  OSWakeUp.fromJson(Map<dynamic, dynamic> json)
      : ret = int.tryParse(json['ret'].toString()),
        msg = json['msg'],
        data = json['data']!=null? OSWakeUpData.fromJson(json['data']) : null;
}
