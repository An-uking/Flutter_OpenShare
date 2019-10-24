class AppConfig {
  static const String appId = "6798ba831ab1c50279fa44436271a09d";
  static const String apiBaseUrl = "https://service.openshare.cc";
  static const String noPic="assets/images/nopic.webp";
  static const List<dynamic> httpServiceError=[
    {"ret": -10000, "msg": "不能连接到服务器"},
    {"ret": -10001, "msg": "网络请求超时"},
    {"ret": -10002, "msg": "应用出错，已上报"},    
    {"ret": -10003, "msg": "服务器故障，网管正在抢修"},
    {"ret": -10004, "msg": "网络请求已取消"},
    {"ret": -10005, "msg": "不能连接到服务器"},
  ];
}
