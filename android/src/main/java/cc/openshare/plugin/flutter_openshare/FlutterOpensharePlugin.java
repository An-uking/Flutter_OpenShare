package cc.openshare.plugin.flutter_openshare;

//import cc.openshare.sdk.opensharesdk.OpenShareCore;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import cc.openshare.sdk.opensharesdk.listener.InstallListener;
import cc.openshare.sdk.opensharesdk.listener.WakeUpListener;
import cc.openshare.sdk.opensharesdk.model.OSInstall;
import cc.openshare.sdk.opensharesdk.model.OSWakeUp;
import cc.openshare.sdk.opensharesdk.OpenShare;

import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;



/** FlutterOpensharePlugin */
public class FlutterOpensharePlugin implements MethodCallHandler, PluginRegistry.NewIntentListener {
  final private Context context;
  final private MethodChannel methodChannel;
//  final private Registrar registrar;
private String initialLink;
  private String latestLink;
private BroadcastReceiver changeReceiver;
  final private WakeUpListener wakeUpListener=new WakeUpListener() {
    @Override
    public void onWakeUpFinish(OSWakeUp osWakeUp) {
      methodChannel.invokeMethod("wakeup",osWakeUpToMap(osWakeUp));
    }
  };

  public FlutterOpensharePlugin(Registrar registrar,MethodChannel channel){
//    this.registrar=registrar;
    this.context=registrar.context();
    this.methodChannel=channel;
    OpenShare.getInstance().setInstallListener(new InstallListener() {
      @Override
      public void onInstallFinish(OSInstall osInstall) {
          methodChannel.invokeMethod("install",osInstallToMap(osInstall));
      }
    });
    OpenShare.getInstance().setWakeUpListener(registrar.activity().getIntent(),wakeUpListener);
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null) {
      return;
    }
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "openshare.cc/Flutter_OpenShare");
    final FlutterOpensharePlugin instance=new FlutterOpensharePlugin(registrar,channel);
    channel.setMethodCallHandler(instance);
    registrar.addNewIntentListener(instance);
  }
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if(call.method.equals("setup")){
      OpenShare.getInstance().init(context);
      result.success(null);
    }else if (call.method.equals("getInstallParams")) {
      OSInstall osInstall=OpenShare.getInstance().getInstallParams();
      result.success(osInstallToMap(osInstall));
    }else if (call.method.equals("getWakeUpParams")) {
      OSWakeUp osWakeUp=OpenShare.getInstance().getWakeUpParams();
      result.success(osWakeUpToMap(osWakeUp));
    }else if (call.method.equals("getUUID")) {
      String uuid=OpenShare.getInstance().getUUID();
      result.success(uuid);
    } else {
      result.notImplemented();
    }
  }

  private Map<String,Object> osInstallToMap(OSInstall osInstall){
    Map<String,Object> map=new HashMap<>();
    map.put("ret",osInstall.ret);
    map.put("msg",osInstall.msg);
    if(osInstall.ret==0&&osInstall.data!=null){
      Map<String,Object> data=new HashMap<>();
//      data.put("key",osKeyVal.data.key);
      data.put("value",osInstall.data.params);
      data.put("channelCode",osInstall.data.channelCode);
      map.put("data",data);
    }
    return map;
  }
  private Map<String,Object> osWakeUpToMap(OSWakeUp osWakeUp){
    Map<String,Object> map=new HashMap<>();
    map.put("ret",osWakeUp.ret);
    map.put("msg",osWakeUp.msg);
    if(osWakeUp.ret==0&&osWakeUp.data!=null){
      Map<String,Object> data=new HashMap<>();
//      data.put("key",osWakeUp.data.key);
      data.put("val",osWakeUp.data.val);
      data.put("path",osWakeUp.data.path);
      map.put("data",data);
    }
    return map;
  }
  @Override
  public boolean onNewIntent(Intent intent) {
    OpenShare.getInstance().setWakeUpListener(intent, wakeUpListener);
    return false;
  }
}
