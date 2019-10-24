import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_openshare_example/widgets/function.dart';
import 'package:flutter_openshare_example/services/http_process.dart';
import 'package:flutter_openshare_example/widgets/reward_widget.dart';

showSuccess(BuildContext context, String message, IconData icon) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      icon,
                      color: Colors.green,
                      size: 28.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ));
}

showProgress(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFF6600)),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "请稍等……",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ));
}

// showProgress(BuildContext context) {
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//             child: Container(
//               width: 60.0,
//               height: 60.0,
//               padding: EdgeInsets.all(15.0),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(3.0),
//                   color: Color(0xFFF2F3F5)),
//               child: CircularProgressIndicator(
//                      strokeWidth: 2.0,
//                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6600)),
//                   ),
//             ),
//           ));
// }

hideProgress(BuildContext context) {
  Navigator.pop(context);
}

closeDialog(BuildContext context) {
  Navigator.pop(context);
}

processObservable(Stream<HttpProcess> process, BuildContext context,
    {int time, Function callback}) {
  process.listen((HttpProcess p) {
    if (p.loading) {
      showProgress(context);
    } else {
      setTimeOut(() {
        hideProgress(context);
        if (callback != null) {
          callback(p.response);
        }
      }, time: time ?? 1);
    }
  });
}

void showModelBottomMenu(
    {@required BuildContext context,
    double itemHeight,
    @required List<String> menus,
    @required Function onTap}) {
  final double itemH = itemHeight ?? 45.0;
  final int len = menus.length;
  int index = 1;
  final double totalLen = (itemH + 0.5) * len + 50.5;
  final listWidget = menus.map((name) {
    return Container(
      height: itemH,
      decoration: index++ == len
          ? null
          : BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0xFFE5E5E5), width: 0.5))),
      child: Material(
        color: Color(0xFFFFFFFF),
        child: InkWell(
          onTap: () {
            closeDialog(context);
            onTap(menus.indexOf(name));
          },
          child: Center(
            child: Text(name,style: TextStyle( color: Color(0xFF000000), fontSize: 16.0),),
          ),
        ),
      ),
    );
  }).toList();
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
        height: totalLen,
        color: Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Column(
              children: listWidget,
            ),
            Container(
              height: itemH,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xFFF2F3F5), width: 6.0))),
              child: Material(
                color: Color(0xFFFFFFFF),
                child: InkWell(
                  onTap: () {
                    closeDialog(context);
                    onTap(-1);
                  },
                  child: Center(
                    child: Text(
                      "取消",
                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                      
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
  );
}
///
///显示消息
///
void showSnackBarMessage(ScaffoldState state, String msg) {
  state.showSnackBar(SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 2),
  ));
}

Widget _rewardWidget(String name,Function callback) {
  final _priceItem = <GoldMoney>[
    GoldMoney(isSelected: true, price: 10),
    GoldMoney(isSelected: false, price: 100),
    GoldMoney(isSelected: false, price: 250),
    GoldMoney(isSelected: false, price: 520),
    GoldMoney(isSelected: false, price: 999),
    GoldMoney(isSelected: false, price: 1314)
  ];
  return Container(
    width: double.infinity,
    padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
    child: Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text.rich(
                TextSpan(style: TextStyle(fontSize: 18.0), children: <TextSpan>[
              TextSpan(text: "打赏给", style: TextStyle(color: Color(0xFF000000))),
              TextSpan(text: name, style: TextStyle(color: Color(0xFFFF5A5F))),
            ])),
            Reward(
              items: _priceItem,
              onTap: (int price) {
                if(callback!=null){
                  callback(price);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
void rewardDialog(BuildContext context,String name, Function callback){
  var curPrice=10;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _rewardWidget(name,(price)=>curPrice=price),
                FloatingActionButton(
                  backgroundColor: Color(0xFFFF5A5F),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if(callback!=null){
                      callback(curPrice);
                    }

                  },
                )
              ],
            ),
          ));
}
payDialog(BuildContext context,int price,{Function callback}) {
  // setState(() {
  //   isDataAvailable = true;
  // });
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _payWidget(price),
                FloatingActionButton(
                  backgroundColor: Color(0xFFFF5A5F),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if(callback!=null){
                      callback();
                    }
                  },
                )
              ],
            ),
          ));
}

_payWidget(int price) => Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "提示",
                style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 18.0),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text("该动态为付费内容", style: TextStyle(color: Color(0xFF000000))),
              Text.rich(TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "打赏", style: TextStyle(color: Color(0xFF000000))),
                TextSpan(
                    text: "${price}YB", style: TextStyle(color: Color(0xFFFF5A5F))),
                TextSpan(
                    text: "解锁该动态", style: TextStyle(color: Color(0xFF000000)))
              ])),
            ],
          ),
        ),
      ),
    );
