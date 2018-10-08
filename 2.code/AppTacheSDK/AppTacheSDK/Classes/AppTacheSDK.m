//
//  AppTacheSDK.m
//  AppTache
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "AppTacheSDK.h"
#import "TSLoginViewController.h"

#define kDataActiveKey    @"dataActive"
#define kDataActiveValue  @"YES"

static AppTacheSDK* _instance = nil;

@interface AppTacheSDK() <SdkManagerDelegate>
{
    BOOL _isInit;
    BOOL _isLogin;
}

@end

@implementation AppTacheSDK

+ (AppTacheSDK *)sharedInstance
{
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _isInit  = NO;
        _isLogin = NO;
    }
    
    return self;
}

/*
 获取SDK版本号，返回字符串，如: @"1.0.0"
 */
- (NSString*)getSdkVersion
{
    return kSdkVersion;
}

/*
 初始化
 */
- (void)initSdkWithGameCode:(NSString *)gameCode platformId:(NSString *)platformId
{
    DLog(@"gameCode=%@, platformId=%@", gameCode, platformId);
    
    [TSAppModel shareInstance].gameCode = [CommTool safeString:gameCode];
    [TSAppModel shareInstance].platformId = [CommTool safeString:platformId];
    
    // 激活 （打点）
    NSString* tempValue = [[NSUserDefaults standardUserDefaults] objectForKey:kDataActiveKey];
    if (tempValue == nil || ![tempValue isEqualToString:kDataActiveValue])
    {
        [[SdkManager shareInstance] sdkDataActive:@{} success:^{
            [[NSUserDefaults standardUserDefaults] setObject:kDataActiveValue forKey:kDataActiveKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
    
    [SdkManager shareInstance].delegate = self;
    [[SdkManager shareInstance] sdkInit];
    
    _isInit = YES;
    
    if ([_delegate respondsToSelector:@selector(appTacheSdkDidInitSuccess)]) {
        [_delegate appTacheSdkDidInitSuccess];
    }
}


/*
 登录
 */
- (void)login
{
    DLog();
    
    if (!_isInit) {
        [CommTool showStaus:@"SDK未初始化" withType:TSMessageTypeWarnning];
        return;
    }
    
    if (_isLogin) {
        [CommTool showStaus:@"已登录" withType:TSMessageTypeInfo];
        return;
    }
    
    UIWindow* keyWindow = [CommTool getCurrentWindow];
    UIViewController* rootVC = keyWindow.rootViewController;
    
    TSLoginViewController* loginVC = [TSLoginViewController new];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }else{
        rootVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    
    if (rootVC.presentedViewController == nil){
        [rootVC presentViewController:loginVC animated:YES completion:nil];
    }
}


/*
 注销
 */
- (void)logout
{
    if (_isLogin == NO) {
        [CommTool showStaus:@"请先登录" withType:TSMessageTypeInfo];
        return;
    }
    
    [[SdkManager shareInstance] sdkLogout:^{
        DLog();
    }];
}


/*
 支付
 
 @param1: money       商品价格;
 @param2: roleId      角色ID;
 @param3: roleName    角色名称;
 @param4: serverId    服务器id;
 @param5: serverName  服务器名称
 @param6: extInfo     扩展参数
 @param7: currency    货币类型
 @param8: cpOrderNo   cp订单号
 */
- (void)requestPay:(NSDictionary*)params
{
    if (_isLogin == NO) {
        [CommTool showStaus:@"请先登录" withType:TSMessageTypeInfo];
        return;
    }
    
    [[SdkManager shareInstance] sdkRequestPay:params success:^{
        DLog();
    }];
}


/*
 数据打点
 
 @param1: serverId   服务器ID;
 @param2: serverName 服务器名称;
 @param3: roleId     角色ID;
 @param4: roleName   角色名称;
 @param4: roleLevel  角色等级;
 */
- (void)addDataType:(ATDataType)type params:(NSDictionary*)params
{
    if (_isLogin == NO) {
        [CommTool showStaus:@"请先登录" withType:TSMessageTypeInfo];
        return;
    }
    
    switch (type) {
        case ATDataTypeCreateRole:
            [[SdkManager shareInstance] sdkDataCreateRole:params success:^{
                DLog();
            }];
            break;
        case ATDataTypeEnterGame:
            [[SdkManager shareInstance] sdkDataEnterGame:params success:^{
                DLog();
            }];
            break;
        case ATDataTypeLevelUp:
            [[SdkManager shareInstance] sdkDataLevelUp:params success:^{
                DLog();
            }];
            break;
        default:
            break;
    }
}


/*
 显示悬浮窗
 */
- (void)showFloat
{
    if (_isLogin == NO) {
        [CommTool showStaus:@"请先登录" withType:TSMessageTypeInfo];
        return;
    }
    [[SdkManager shareInstance] sdkShowFloatView];
}


/*
 隐藏悬浮窗
 */
- (void)hideFloat
{
    [[SdkManager shareInstance] sdkHideFloatView];
}

#pragma mark - SdkManagerDelegate

- (void)sdkManagerDidLoginSuccess:(NSDictionary *)result
{
    DLog();
    
    _isLogin = YES;
    
    if ([self.delegate respondsToSelector:@selector(appTacheSdkDidLoginSuccess:)]) {
        [self.delegate appTacheSdkDidLoginSuccess:result];
    }
}

- (void)sdkManagerDidLoginFail:(NSDictionary *)result
{
    DLog();
}

- (void)sdkManagerDidLogoutSuccess:(NSDictionary *)result
{
    DLog();
    
    _isLogin = NO;
    
    if ([self.delegate respondsToSelector:@selector(appTacheSdkDidLogoutSuccess)]) {
        [self.delegate appTacheSdkDidLogoutSuccess];
    }
}

- (void)sdkManagerDidPaySuccess:(NSDictionary *)result
{
    DLog();
    
    if ([self.delegate respondsToSelector:@selector(appTacheSdkDidPaySuccess:)]) {
        [self.delegate appTacheSdkDidPaySuccess:result];
    }
}

- (void)sdkManagerDidPayFail:(NSDictionary *)result
{
    if ([self.delegate respondsToSelector:@selector(appTacheSdkDidPayFailed:)]) {
        [self.delegate appTacheSdkDidPayFailed:result];
    }
}

- (void)sdkManagerDidPayCancel:(NSDictionary *)result
{
    if ([self.delegate respondsToSelector:@selector(appTacheSdkDidPayCancel:)]) {
        [self.delegate appTacheSdkDidPayCancel:result];
    }
}

#pragma mark - 周期函数

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
