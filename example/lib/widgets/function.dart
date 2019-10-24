import 'package:flutter_openshare_example/widgets/countdown.dart';
// import 'package:meiying/utils/countdown.dart';

void setTimeOut(Function callback,{time:1}){
    if(callback!=null){
      var timeout=new CountDown(Duration(seconds: time));
      var timeStream=timeout.stream.listen(null);
      timeStream.onDone(callback);
    }
  }

 String formatMsgTime (String timespan) {
  var dateTime= DateTime.parse(timespan);

  var year = dateTime.year;
  var month = dateTime.month;
  var day = dateTime.day;
  var hour = dateTime.hour;
  var minute = dateTime.minute;
  //var second = dateTime.second;
  var now = new DateTime.now();
  //var now_new = Date.parse(now.toDateString());  //typescript转换写法

  var milliseconds = 0;
  String timeSpanStr;

  milliseconds = now.difference(dateTime).inMilliseconds;

  if (milliseconds <= 1000 * 60 * 1) {
    timeSpanStr = '刚刚';
  }
  else if (1000 * 60 * 1 < milliseconds && milliseconds <= 1000 * 60 * 60) {
    timeSpanStr ='${(milliseconds / (1000 * 60)).floor()}分钟前';
  }
  else if (1000 * 60 * 60 * 1 < milliseconds && milliseconds <= 1000 * 60 * 60 * 24) {
    timeSpanStr =  '${(milliseconds / (1000 * 60 * 60)).floor()}小时前';
  }
  else if (1000 * 60 * 60 * 24 < milliseconds && milliseconds <= 1000 * 60 * 60 * 24 * 15) {
    timeSpanStr =  '${(milliseconds / (1000 * 60 * 60 * 24)).floor()}天前';
  }
  else if (milliseconds > 1000 * 60 * 60 * 24 * 15 && year == now.year) {
    timeSpanStr ="${month}-${day} ${hour}:$minute";
  } else {
    timeSpanStr ="${year}-${month}-${day}";
  }
  return timeSpanStr;
}