import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openshare_example/bloc/base_provider_bloc.dart';
// import 'package:rxdart/subjects.dart';

class AppBloc extends BlocBase {
  final _localeController = new StreamController<Locale>();
  final _themeController = new StreamController<ThemeData>();
  Locale locale;

  //多语言
  StreamSink<Locale> get localeSink => _localeController.sink;
  Stream<Locale> get localeStream => _localeController.stream;
  //多主题
  StreamSink<ThemeData> get themeSink => _themeController.sink;
  Stream<ThemeData> get themeStream => _themeController.stream;

  final ThemeData normalTheme = new ThemeData(
      // platform: TargetPlatform.android,
      primaryColorBrightness: Brightness.light,
      brightness: Brightness.light,
      primaryColor: Color(0xFFFF5A5F),//原色
      // indicatorColor: Color(0xFFFF5A5F),
      primaryColorDark: Color(0xFFF2F2F2),
      primaryColorLight: Color(0xFFF8F8F8),
      backgroundColor: Color(0xFFFFFFFF),//背景颜色
      scaffoldBackgroundColor:Color(0xFFF2F3F5),//脚手架背景颜色
      dividerColor: Color(0XFFF0F0F0),
      buttonColor: Color(0xFFFF5A5F),
      cardColor: Color(0xFFF2F3F5),
      indicatorColor: Color(0xFFFF5A5F),
      textTheme: TextTheme(
          title: TextStyle(color: Color(0XFF000000),fontSize: 18.0),
          body1: TextStyle(color: Color(0XFF666666),fontSize: 14.0),
          body2: TextStyle(color: Color(0XFF666666),fontSize: 12.0),
          display1: TextStyle(color: Color(0xFFFF5A5F),fontSize: 20.0),
          display2: TextStyle(color: Color(0XFF5fe8de),fontSize: 12.0),
          display3: TextStyle(color: Color(0XFF5fe8de),fontSize: 14.0),
          display4: TextStyle(color: Color(0xFFCCCCCC),fontSize: 16.0),
        ),
      dialogBackgroundColor: Colors.transparent,
      accentColor: Color(0xFFFF5A5F),
      fontFamily: "PingFang SC"
      );
  final ThemeData darkTheme = new ThemeData(
      primaryColorBrightness: Brightness.dark,
      brightness: Brightness.dark,
      primaryColor: Color(0XFFFFFFFF),
      primaryColorDark: Color(0XFF22283E),
      primaryColorLight: Color(0XFF282E46),
      backgroundColor: Color(0xFF141A32),//背景颜色
      scaffoldBackgroundColor:Color(0xFF141A32),//脚手架背景颜色
      buttonColor: Color(0xFFFF5A5F),
      cardColor: Color(0xFF151521),
      indicatorColor: Color(0XFFfcfdfe),//tabbar
      dividerColor: Color(0xFF696969),//分割线、边框线
      
      textTheme: TextTheme(
          title: TextStyle(color: Color(0XFFCCCCCC),fontSize: 18.0),
          body1: TextStyle(color: Color(0XFFBEBFC1),fontSize: 14.0),
          body2: TextStyle(color: Color(0XFFF2F3F5),fontSize: 12.0),
          display1: TextStyle(color: Color(0xFFFF5A5F),fontSize: 20.0),
          display2: TextStyle(color: Color(0XFFCCCCCC),fontSize: 14.0),
          display3: TextStyle(color: Color(0XFF5fe8de),fontSize: 14.0),
          display4: TextStyle(color: Color(0XFF5fe8de),fontSize: 16.0),
        ),
          
          // buttonColor: Color(0XFFfcfdfe),
      dialogBackgroundColor: Colors.transparent,
      accentColor: Color(0XFFCCCCCC),
      fontFamily: "PingFang SC"
      );

  AppBloc() {
    // _localeController.stream.listen(_listen);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _localeController.close();
    _themeController.close();
  }
}
