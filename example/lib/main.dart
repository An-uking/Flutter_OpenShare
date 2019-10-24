import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_openshare/flutter_openshare.dart';
import 'package:flutter_openshare_example/auto_invitecode.dart';
import 'package:flutter_openshare_example/bloc/home_page_bloc.dart';
import 'package:flutter_openshare_example/models/user_model.dart';
import 'package:flutter_openshare_example/services/http_response.dart';
import 'package:flutter_openshare_example/widgets/common_dialogs.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  final _homePageKey=GlobalKey<ScaffoldState>();
  HomePageBloc _bloc;
  @override
  void initState() {
    super.initState();
    _bloc = new HomePageBloc();
    _bloc.responseStream.listen(responseCallback);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _bloc.init();
  }
  void responseCallback(HttpServiceResponse res) {
    showSnackBarMessage(_homePageKey.currentState,res.msg);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homePageKey,
      appBar: AppBar(
        title: Text("OpenShare App推广助手"),
        centerTitle: true,
      ),
      body: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,          
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: <Widget>[
                StreamBuilder<CombObj>(
                  initialData: null,
                  stream: _bloc.combSubject.stream,
                  builder: (_, snapshot) => TextField(
                        enabled: snapshot.data==null||snapshot.data.user==null,
                        controller: _bloc.controller,
                        focusNode: _bloc.nameFocusNode,
                        onChanged: _bloc.nameTextChange,
                        maxLength: 12,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.shade100,
                            filled: true,
                            hintText: '用户名',
                            errorText:snapshot.data!=null? snapshot.data.errTxt:null),
                      ),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<String>(
                  initialData: "",
                  stream: _bloc.inviteUserSubject.stream,
                  builder: (_,snapshot)=>Text("邀请人:${snapshot.data}"),
                ),

                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  
                  color: Color(0xFFFF6600),
                  textColor: Color(0xFFFFFFFF),
                  onPressed: () {
                    _bloc.bindName();
                  },
                  child: Text("绑定"),
                ),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  color: Color(0xFFFF6600),
                  textColor: Color(0xFFFFFFFF),
                  onPressed: () {
                    _bloc.ewmTap(context);
                  },
                  child: Text("推广二维码"),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<String>(
                  initialData: "",
                  stream: _bloc.wakeupSubject.stream,
                  builder: (_,snapshot)=>Text("唤醒参数:${snapshot.data}"),
                ),
              ],
            )),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String _installVal = 'Unknown';
  // String _wakeupVal = 'Unknown';
  // String _installVal2 = 'Unknown';
  // String _wakeupVal2 = 'Unknown';
  // FlutterOpenshare _openshare;
  @override
  void initState() {
    super.initState();
    // _openshare = new FlutterOpenshare();
    // _openshare.addEventHandler(onInstallMessage: (OSInstall res) {
    //   setState(() {
    //     _installVal = res.ret == 0 ? res.data.value : res.msg;
    //   });
    // }, onWakeUpMessage: (OSWakeUp res) {
    //   setState(() {
    //     _wakeupVal = res.ret == 0 ? res.data.val : res.msg;
    //   });
    // });
    // _openshare.setup();

    // initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenShareSDK Flutter Plugin'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              // Text('自动获取邀请码'),
              // Text('安装参数: $_installVal'),
              // Text('唤醒参数: $_wakeupVal'),
              // SizedBox(
              //   height: 30,
              // ),
              // Text('主动获取安装参数: $_installVal2'),
              // Text('主动获取唤醒参数: $_wakeupVal2'),
              // RaisedButton(
              //   onPressed: () {
              //     _openshare.getInstallParams().then((res) {
              //       setState(() {
              //         _installVal2 = res.ret == 0 ? res.data.value : res.msg;
              //       });
              //     });
              //   },
              //   child: Text("getInstallParams"),
              // ),
              // RaisedButton(
              //   onPressed: () {
              //     _openshare.getWakeUpParams().then((res) {
              //       setState(() {
              //         _wakeupVal2 = res.ret == 0 ? res.data.val : res.msg;
              //       });
              //     });
              //   },
              //   child: Text("getWakeUpParams"),
              // ),
              RaisedButton(
                onPressed: () {},
                child: Text("邀请码"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (_) => InviteFriendPage(), maintainState: false));
                },
                child: Text("软文推广"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("广告投放"),
              ),
              RaisedButton(
                onPressed: () {},
                child: Text("商品分销"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
