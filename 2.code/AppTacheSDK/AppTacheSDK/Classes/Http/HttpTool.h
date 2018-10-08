//
//  HttpTool.h
//  AppTache
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HttpRequest.h"

@interface HttpTool : HttpRequest

#pragma mark - 验证码相关接口
/**
 获取验证码
 */
+ (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSString*)type success:(successBlock)success failure:(failureBlock)failure;

/**
 提交验证码
 */
+ (void)submitVerificationCode:(NSString*)code serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure;


#pragma mark - 帐号管理相关接口
/**
 获取账号(一键注册时，为了获取唯一的用户账号。)
 */
+ (void)getAccountSuccess:(successBlock)success failure:(failureBlock)failure;

/**
 获取账号信息
 */
+ (void)getAccountInfoWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure;

/**
 获取设备上的账号列表
 */
+ (void)getAccountListWithDeviceId:(NSString*)deviceId success:(successBlock)success failure:(failureBlock)failure;

/**
 账号绑定接口
 */
+ (void)bindAccount:(NSString*)account password:(NSString*)password token:(NSString*)token phone:(NSString*)phone verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure;

/**
 账号解绑接口
 */
+ (void)unbindAccount:(NSString*)account password:(NSString*)password token:(NSString*)token phone:(NSString*)phone verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure;

/**
 密码修改接口
 */
+ (void)modifyPasswordWithAccount:(NSString*)account type:(NSInteger)type oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 帐号注册相关接口

/**
 注册
 */
+ (void)registerWithParams:params success:(successBlock)success failure:(failureBlock)failure;

/**
 获取注册时候用户协议
 */
+ (void)getUserProtocolWithSourceId:(NSString*)sourceId appId:(NSString*)appId type:(int)type success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 帐号登录相关接口

/**
 账号登录
 */
+ (void)loginWithParams:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 账号验证接口
 */
+ (void)checkAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure;

/**
 账号登录验证接口
 */
+ (void)checkAccountLoginStateWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure;

/**
 账号注销接口
 */
+ (void)logoutWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token gameCode:(NSString*)gameCode success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 支付相关接口
/**
 订单创建接口
 */
+ (void)createOrderNO:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 查询订单支付订单状态接口 (支付宝或者微信在支付流程完成后查询订单是否支付成功或失败)
 */
+ (void)tradeQuery:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 内购订单创建接口
 */
+ (void)createOrderNOForIAP:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 内购验证凭据接口
 */
+ (void)checkIapReceipt:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

#pragma mark - 打点接口
/**
 打点
 */
+ (void)dataReportWithType:(NSInteger)type info:(NSString*)info body:(NSString*)body success:(successBlock)success failure:(failureBlock)failure;

@end



