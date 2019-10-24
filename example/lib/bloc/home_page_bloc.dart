import 'package:flutter/cupertino.dart';
import 'package:flutter_openshare_example/auto_invitecode.dart';
import 'package:flutter_openshare_example/bloc/base_provider_bloc.dart';
import 'package:flutter_openshare_example/models/user_model.dart';
import 'package:flutter_openshare_example/services/http_response.dart';
import 'package:flutter_openshare/flutter_openshare.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class HomePageBloc extends BlocBase {
  final resultResponse = new BehaviorSubject<HttpServiceResponse>();
  Observable<HttpServiceResponse> get responseStream => resultResponse.stream;
  // final userSubject = new BehaviorSubject<User>();
  final combSubject = new BehaviorSubject<CombObj>();
  // final bindFlagSubject = new BehaviorSubject<bool>();
  final inviteUserSubject = new BehaviorSubject<String>();
  final wakeupSubject = new BehaviorSubject<String>();
  final FlutterOpenshare _openshare = new FlutterOpenshare();
  final FocusNode nameFocusNode = new FocusNode();
  TextEditingController controller = new TextEditingController();
  MmkvFlutter _mmkv;
  String _name;
  bool _nameFlag;
  String _uuid;
  String _inviteUser = "";
  User user;
  CombObj _combObj;
  // bool bing

  HomePageBloc() {
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        if (_name == null || _name.isEmpty) {
          combSubject.add(CombObj(errTxt: "密码不能为空"));
          // nameSubject.add("密码不能为空");
        } else {
          combSubject.add(CombObj(errTxt: _nameFlag ? null : "密码格式有误"));
        }
      } else {
        combSubject.add(CombObj(errTxt: null));
      }
    });
  }

  void init() async {
    _mmkv = await MmkvFlutter.getInstance();
    _openshare.addEventHandler(
        onInstallMessage: _onInstall, onWakeUpMessage: _onWakeUp);
    // _openshare.setup();

    var userStr = await _mmkv.getString("OS_USER");
    if (userStr != null && userStr != "") {
      user = User.formString(userStr);
      controller.text = user.name;
      _combObj = CombObj(user: user);
      combSubject.add(_combObj);
    } else {
      load();
    }
  }

  void _onInstall(OSInstall res) async {
    // print(res);
    _inviteUser = await _mmkv.getString("OS_INVITE_USER");
    if (_inviteUser != null && _inviteUser != "") {
      inviteUserSubject.add(_inviteUser);
    } else {
      if (res.ret == 0) {
        Map<String, dynamic> osRes = json.decode(res.data.value);
        // print(osRes['name']);
        _inviteUser = osRes['name'] != null ? osRes['name'] : '';
        _mmkv.setString("OS_INVITE_USER", _inviteUser);
        inviteUserSubject.add(_inviteUser);
      }
    }
  }

  void _onWakeUp(OSWakeUp res) {
    wakeupSubject.add(res.ret == 0 ? res.data.val : res.msg);
  }

  Future<Null> load() async {
    _uuid = await _openshare.getUUID();
    var res = await http.get("/api/test/load?uuid=" + _uuid);
    HttpServiceResponse result = res.data;
    if (result.ret == 0) {
      user = User.fromJson(result.data);
      _mmkv.setString("OS_USER", user.toListString());
      controller.text = user.name;
      _combObj = CombObj(user: user);
      combSubject.add(_combObj);
      // userSubject.add(user);
    }
  }

  Future<Null> bindName() async {
    if (_combObj != null && _combObj.user != null) return;
    if (!_nameFlag) return;
    _uuid = await _openshare.getUUID();
    var res = await http.get<HttpServiceResponse>("/api/test/name/bind?name=" +
        _name +
        "&uuid=" +
        _uuid +
        "&key=6180b45ab2b7ab1975bb839bf9b97ec4&code=28652140235841" +
        (_inviteUser != "" ? ("&invite=" + _inviteUser) : ""));
    HttpServiceResponse result = res.data;
    if (result.ret == 0) {
      user = User(name: _name, hashURL: result.data);
      _mmkv.setString("OS_USER", user.toListString());
      _combObj = CombObj(user: user);
      combSubject.add(_combObj);
    }
    resultResponse.add(result);
  }

  void nameTextChange(txt) {
    _name = txt;
    _nameFlag = new RegExp(r"^[a-zA-Z][a-zA-Z0-9_]{4,12}$").hasMatch(_name);
  }

  Future<Null> ewmTap(BuildContext context) async {
    if (_combObj == null || _combObj.user == null) return;
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => InviteFriendPage(
              user: _combObj.user,
            ),
        maintainState: false));
  }

  @override
  void dispose() {
    combSubject.close();
    resultResponse.close();
  }
}
