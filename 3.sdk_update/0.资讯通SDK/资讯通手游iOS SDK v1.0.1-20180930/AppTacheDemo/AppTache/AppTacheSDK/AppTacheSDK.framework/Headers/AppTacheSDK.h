//
//  AppTacheSDK.h
//  AppTache
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppTacheSDKDelegate;

// 数据打点类型
typedef NS_ENUM(NSInteger, ATDataType)
{
    ATDataTypeCreateRole = 0,  // 角色创建
    ATDataTypeEnterGame,       // 角色进入游戏
    ATDataTypeLevelUp,         // 角色升级
};

@interface AppTacheSDK : NSObject

@property (nonatomic, weak)id<AppTacheSDKDelegate> delegate;

/**
 单例
 */
+ (AppTacheSDK *)sharedInstance;


/*
 获取SDK版本号，返回字符串，如: @"1.0.0"
 */
- (NSString*)getSdkVersion;


/*
 初始化
 */
- (void)initSdkWithGameCode:(NSString*)gameCode platformId:(NSString*)platformId;


/*
 登录
 */
- (void)login;


/*
 注销
 */
- (void)logout;


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
- (void)requestPay:(NSDictionary*)params;

/*
 数据打点
 
 @param1: serverId   服务器ID;
 @param2: serverName 服务器名称;
 @param3: roleId     角色ID;
 @param4: roleName   角色名称;
 @param4: roleLevel  角色等级;
 */
- (void)addDataType:(ATDataType)type params:(NSDictionary*)params;


/*
 显示悬浮窗
 */
- (void)showFloat;


/*
 隐藏悬浮窗
 */
- (void)hideFloat;


#pragma mark - 周期函数

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

@end


@protocol AppTacheSDKDelegate <NSObject>

- (void)appTacheSdkDidInitSuccess;

- (void)appTacheSdkDidLoginSuccess:(NSDictionary*)result;

- (void)appTacheSdkDidLogoutSuccess;

- (void)appTacheSdkDidPaySuccess:(NSDictionary*)result;

- (void)appTacheSdkDidPayFailed:(NSDictionary*)result;

- (void)appTacheSdkDidPayCancel:(NSDictionary*)result;

@end


