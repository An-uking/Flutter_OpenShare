//
//  OpenShare.h
//  OpenShareTest
//
//  Created by uking on 4/5/19.
//  Copyright © 2019 uking. All rights reserved.
//

#import<Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^getInstallCallback)( id  _Nullable params);
@protocol OpenShareDelegate <NSObject>
/**
 * 安装时获取自定义h5页面参数（使用控制中心提供的渠道统计时，渠道编号也会返回给开发者）
 * @ param params 动态参数
 * @ return void
 */
- (void)getInstallParamsFromSmartInstall:(id) params withError: (NSError *) error;
/**
 * 唤醒时获取h5页面参数（如果是渠道链接，渠道编号会一起返回）
 * @ param type 链接类型（区分渠道链接和自定义分享h5链接）
 * @ param params 动态参数
 * @ return void
 */
- (void)getWakeUpParamsFromSmartInstall: (id) params withError: (NSError *) error;

@end
@interface OpenShareSDK : NSObject
@property(nonatomic,copy)getInstallCallback installBlock;

+(instancetype)getInitializeInstance;
/**
 该方法可重复获取参数，如只需在首次获取参数，请自行判断，可设置一个标示位，不再重复调用
 getInstallCallBackBlock方法。
 **/
-(void)getInstallParams:(getInstallCallback)callback;
-(void)getWakeUpParams:(getInstallCallback)callback;

/**
 * 初始化ShareInstall SDK 
 * @ param delegate 委托方法(getInstallParamsFromSmartInstall和 getWakeUpParamsFromSmartInstall)所在的类的对象
 * @ param launchOptions 该参数存储程序启动的原因
 * @ return void
 */
+(void)initWithDelegate:(id)delegate withOptions:(NSDictionary *)launchOptions;

/**
 * 处理 URL schemes
 * @ param URL 系统回调传回的URL
 * @ return bool URL是否被ShareInstall识别
 */
+(BOOL)handLinkURL:(NSURL *)URL;

/**
 * 通过 Universal Link 启动应用时会调用 application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable
 restorableObjects))restorationHandler ,在此方法中调用  [ShareInstallSDK continueUserActivity:userActivity]
 * @ param userActivity 存储了页面信息，包括url
 * @ return bool URL是否被ShareInstall识别
 */
+(BOOL)continueUserActivity:(NSUserActivity*)userActivity;

/**
 * 使用Shareinstall 控制中心提供的渠道统计时，在App用户注册完成后调用，可以统计渠道注册量。
 * @ param
 * @ return void
 */
+(void)reportRegister;
/**
 * 普通的获取UUID的方法
 */
+ (NSString *)getUUID;
@end

NS_ASSUME_NONNULL_END
