import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_openshare_example/models/user_model.dart';
import 'package:flutter_openshare_example/widgets/function.dart';
import 'package:flutter_openshare_example/widgets/common_dialogs.dart';
import 'package:flutter_openshare_example/widgets/coupon_box.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

class InviteFriendPage extends StatefulWidget {
  final User user;
  InviteFriendPage({this.user});
  @override
  _InviteFriendPageState createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends State<InviteFriendPage> {
  final GlobalKey _key = GlobalKey<_InviteFriendPageState>();
  final List<String> _bottomMenus = [
    "保存二维码",
    "分享给微信好友",
    "分享到朋友圈",
    "分享到QQ空间",
    "分享到微博"
  ];
  @override
  void initState() {
    super.initState();
  }

  void _showMenus() async {
    showModelBottomMenu(
        context: context,
        menus: _bottomMenus,
        onTap: (index) {
          if (index == 0) {
            _captureImage();
          } else if (index == 1) {}
        });
  }

  void _captureImage() async {
    RenderRepaintBoundary boundary = _key.currentContext.findRenderObject();
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    // Uint8List pngBytes = byteData.buffer.asUint8List();
    final result = await ImagePickerSaver.saveFile(
        fileData: byteData.buffer.asUint8List());
    showSuccess(_key.currentContext, "保存成功", Icons.done);
    setTimeOut(() {
      Navigator.pop(_key.currentContext);
    }, time: 2);
    print(result);
  }

  Widget _buildAppBar(BuildContext context) => AppBar(
        //leading: null,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          // color: Theme.of(context).primaryColor,
        ),
        title: Text(
          "邀请好友",
          // textAlign: TextAlign.left,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showMenus();
            },
            icon: Icon(Icons.more_horiz),
          )
        ],
        //leading: null,
        //centerTitle: true,
        //elevation: 0.0,
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: RepaintBoundary(
          key: _key,
          child: CouponBox(
            width: size.width - 30,
            height: size.height - 60 - kToolbarHeight,
            rate: 5 / 7,
            direction: Axis.vertical,
            dashedBorderColor: Colors.white,
            // backgroundColor: Colors.b,
            firstChild: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 30),
                    child: Text(
                      "${widget.user.name}邀请您一起加入我们",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Container(
                    color: Color(0xFFFFFFFF),
                    padding: EdgeInsets.all(5),
                    child: QrImage(
                      version: 10,
                      data:
                          "http://web.888899909.com/index.html?sp=${widget.user.hashURL}",
                      // gapless: false,
                      size: size.width - 120,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            secondChild: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Text(
                      "自动获取邀请码测试",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "成功注册领取50元优惠券",
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
