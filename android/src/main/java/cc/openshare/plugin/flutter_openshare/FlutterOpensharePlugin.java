package cc.openshare.plugin.flutter_openshare;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;
//import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import java.util.HashMap;
import java.util.Map;

import cc.openshare.sdk.opensharesdk.OpenShare;
import cc.openshare.sdk.opensharesdk.listener.InstallListener;
import cc.openshare.sdk.opensharesdk.listener.WakeUpListener;
import cc.openshare.sdk.opensharesdk.model.OSInstall;
import cc.openshare.sdk.opensharesdk.model.OSWakeUp;
import cc.openshare.sdk.opensharesdk.model.OSResponse;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FlutterOpensharePlugin
 */
public class FlutterOpensharePlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener, ActivityAware {
    private Context applicationContext;
    private MethodChannel methodChannel;
    private Activity mainActivity;

    final private WakeUpListener wakeUpListener = new WakeUpListener() {
        @Override
        public void onWakeUpFinish(OSResponse<OSWakeUp> res) {
            methodChannel.invokeMethod("wakeup", osWakeUpToMap(res));
        }
    };


    private void onAttachedToEngine(Context context, BinaryMessenger binaryMessenger) {
        this.methodChannel = new MethodChannel(binaryMessenger, "openshare.cc/Flutter_OpenShare");
        this.applicationContext = context;
        methodChannel.setMethodCallHandler(this);
        OpenShare.getInstance().setInstallListener(new InstallListener() {
            @Override
            public void onInstallFinish(OSResponse<OSInstall> res) {
                methodChannel.invokeMethod("install", osInstallToMap(res));
            }
        });
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
        setActivity(binding.getActivity());
        OpenShare.getInstance().setWakeUpListener(mainActivity.getIntent(), wakeUpListener);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        setActivity(null);
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        binding.addOnNewIntentListener(this);
        setActivity(binding.getActivity());

    }

    @Override
    public void onDetachedFromActivity() {
        this.mainActivity = null;
    }

    private void setActivity(Activity flutterActivity) {
        this.mainActivity = flutterActivity;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("setup")) {
            OpenShare.getInstance().init(this.applicationContext);
            result.success(null);
        } else if (call.method.equals("getInstallParams")) {
            OSResponse<OSInstall> osInstall = OpenShare.getInstance().getInstallParams();
            result.success(osInstallToMap(osInstall));
        } else if (call.method.equals("getWakeUpParams")) {
            OSResponse<OSWakeUp> osWakeUp = OpenShare.getInstance().getWakeUpParams();
            result.success(osWakeUpToMap(osWakeUp));
        } else if (call.method.equals("getUUID")) {
            String uuid = OpenShare.getInstance().getUUID();
            result.success(uuid);
        } else {
            result.notImplemented();
        }
    }

    private Map<String, Object> osInstallToMap(OSResponse<OSInstall> osInstall) {
        Map<String, Object> map = new HashMap<>();
        map.put("ret", osInstall.ret);
        map.put("msg", osInstall.msg);
        if (osInstall.ret == 0 && osInstall.data != null) {
            Map<String, Object> data = new HashMap<>();
            data.put("value", osInstall.data.params);
            data.put("channelCode", osInstall.data.channelCode);
            map.put("data", data);
        }
        return map;
    }

    private Map<String, Object> osWakeUpToMap(OSResponse<OSWakeUp> osWakeUp) {
        Map<String, Object> map = new HashMap<>();
        map.put("ret", osWakeUp.ret);
        map.put("msg", osWakeUp.msg);
        if (osWakeUp.ret == 0 && osWakeUp.data != null) {
            Map<String, Object> data = new HashMap<>();
            data.put("val", osWakeUp.data.val);
            data.put("path", osWakeUp.data.path);
            map.put("data", data);
        }
        return map;
    }

    @Override
    public boolean onNewIntent(Intent intent) {
        OpenShare.getInstance().setWakeUpListener(intent, wakeUpListener);
        return false;
    }
}
