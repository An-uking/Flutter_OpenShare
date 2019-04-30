#import "FlutterOpensharePlugin.h"

@interface FlutterOpensharePlugin()<OpenShareDelegate>
@end
@implementation FlutterOpensharePlugin{
    FlutterMethodChannel* _methodChannel;
    NSDictionary* _launchOptions;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"openshare.cc/Flutter_OpenShare" binaryMessenger:[registrar messenger]];
    FlutterOpensharePlugin* instance = [[FlutterOpensharePlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel{
    self = [super init];
    if(self){
        NSAssert(self, @"super init cannot be nil");
//        _messenger=messenger;
        _methodChannel=channel;
    }
    return self;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setup" isEqualToString:call.method]) {
      [OpenShareSDK initWithDelegate:self withOptions:_launchOptions];
      result(nil);
  } else if([@"getInstallParams" isEqualToString:call.method]){
      [[OpenShareSDK getInitializeInstance] getInstallParams:^(id  _Nullable params) {
          result(params);
      }];
  } else if([@"getWakeUpParams" isEqualToString:call.method]){
      [[OpenShareSDK getInitializeInstance] getWakeUpParams:^(id  _Nullable params) {
          result(params);
      }];
  }else{
    result(FlutterMethodNotImplemented);
  }
}
- (void)getWakeUpParamsFromSmartInstall:(nonnull id)params withError:(nonnull NSError *)error {
//    NSLog(@"---%@",params);
    [_methodChannel invokeMethod:@"wakeup" arguments:params];
//    [self sendReceiverEvent:params];
}

- (void)getInstallParamsFromSmartInstall:(nonnull id)params withError:(nonnull NSError *)error {
//    NSLog(@"---%@",params);
//    [self sendReceiverEvent:params];
    [_methodChannel invokeMethod:@"install" arguments:params];
}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions{
    _launchOptions=launchOptions;
//    _launchOptions.allKeys
    return YES;
}
//Universal Links 通用链接
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //判断是否通过ShareInstall Universal Links 唤起App
    if ([OpenShareSDK continueUserActivity:userActivity]) {
        return YES ;
    }
    return YES;
}
//iOS9以下 URI Scheme
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //判断是否通过ShareInstall URL Scheme 唤起App
    if ([OpenShareSDK handLinkURL:url]) {
        return YES;
    }

    return YES;
}

//iOS9以上 URL Scheme
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options
{
    //判断是否通过ShareInstall URL Scheme 唤起App
    if ([OpenShareSDK handLinkURL:url]) {
        return YES;
    }

    return YES;
}
@end
