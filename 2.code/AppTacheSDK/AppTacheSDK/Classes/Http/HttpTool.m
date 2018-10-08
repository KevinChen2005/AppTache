//
//  HttpTool.m
//  AppTache
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

#pragma mark - 验证码相关接口
/**
 获取验证码
 */
+ (void)getVerificationCodeWithPhone:(NSString*)phone type:(NSString*)type success:(successBlock)success failure:(failureBlock)failure
{
    NSString* url = [NSString stringWithFormat:@"%@?phone=%@&type=%@", kUrl(@"gamesdk-verify/getVerificationCode"), phone, type];
    [self getWithURL:url success:success failure:failure];
                                                                            
//    NSDictionary* params = @{
//                             @"phone"    : [CommTool safeString:phone],
//                             @"type"     : [CommTool safeString:type],
//                             };
//    [self postShowToastWithURL:kUrl(@"gamesdk-verify/getVerificationCode") params:params success:success failure:failure];
}

/**
 提交验证码
 */
+ (void)submitVerificationCode:(NSString*)code serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure
{
    NSString* url = [NSString stringWithFormat:@"%@?verificationCode=%@&serialNo=%@", kUrl(@"gamesdk-verify/submitVerificationCode"), code, serialNo];
    [self getShowToastWithURL:url success:success failure:failure];
    
//    NSDictionary* params = @{
//                             @"verificationCode"    : [CommTool safeString:code],
//                             @"serialNo"     : [CommTool safeString:serialNo],
//                             };
//    [self postShowToastWithURL:kUrl(@"gamesdk-verify/submitVerificationCode") params:params success:success failure:failure];
}


#pragma mark - 帐号管理相关接口
/**
 获取账号(一键注册时，为了获取唯一的用户账号。)
 */
+ (void)getAccountSuccess:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-account/getPlayerAccount") params:params success:success failure:failure];
}

/**
 获取账号信息
 */
+ (void)getAccountInfoWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"account"    : [CommTool safeString:account],
                             @"password"   : [CommTool safeString:password],
                             @"token"      : [CommTool safeString:token],
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-account/getPlayerInfo") params:params success:success failure:failure];
}

/**
 获取设备上的账号列表
 */
+ (void)getAccountListWithDeviceId:(NSString*)deviceId success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"deviceId"    : [CommTool safeString:deviceId],
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-account/getPlayerAccountByDeviceId") params:params success:success failure:failure];
}

/**
 账号绑定/解绑接口
 */
+ (void)bindAccountWithType:(int)type account:(NSString*)account password:(NSString*)password token:(NSString*)token phone:(NSString*)phone verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* paramsTemp = @{
                                 @"account"    : [CommTool safeString:account],
                                 @"password"   : [CommTool safeString:password],
                                 @"token"      : [CommTool safeString:token],
                                 @"phone"   : [CommTool safeString:phone],
                                 @"verificationCode" : [CommTool safeString:verificationCode],
                                 @"serialNo" : [CommTool safeString:serialNo],
                                 @"type"      : @(type),
                                 };
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:paramsTemp];
    
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    
    [self postShowToastWithURL:kUrl(@"gamesdk-account/accountBind") params:params success:success failure:failure];
}

/**
 账号绑定接口
 */
+ (void)bindAccount:(NSString*)account password:(NSString*)password token:(NSString*)token phone:(NSString*)phone verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure
{
    [self bindAccountWithType:0 account:account password:password token:token phone:phone verificationCode:verificationCode serialNo:serialNo success:success failure:failure];
}

/**
 账号解绑接口
 */
+ (void)unbindAccount:(NSString*)account password:(NSString*)password token:(NSString*)token phone:(NSString*)phone verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure
{
    [self bindAccountWithType:1 account:account password:password token:token phone:phone verificationCode:verificationCode serialNo:serialNo success:success failure:failure];
}

/**
 密码修改接口
 */
+ (void)modifyPasswordWithAccount:(NSString*)account type:(NSInteger)type oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode serialNo:(NSString*)serialNo success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* paramsTemp = @{
                             @"account"    : [CommTool safeString:account],
                             @"oldPwd"     : [CommTool safeString:oldPwd],
                             @"password"   : [CommTool safeString:password],
                             @"token"      : [CommTool safeString:token],
                             @"serialNo"   : [CommTool safeString:serialNo],
                             @"verificationCode" : [CommTool safeString:verificationCode],
                             };
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:paramsTemp];
    
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [params setObject:@(type) forKey:@"type"]; // 0-找回密码 1-密码修改固定类型
    
    
    [self postShowToastWithURL:kUrl(@"gamesdk-account/updatePassword") params:params success:success failure:failure];
}

#pragma mark - 帐号注册相关接口

/**
 注册
 */
+ (void)registerWithParams:params success:(successBlock)success failure:(failureBlock)failure
{
    [self postShowToastWithURL:kUrl(@"gamesdk-register/playerRegister") params:params success:success failure:failure];
}

/**
 获取注册时候用户协议
 */
+ (void)getUserProtocolWithSourceId:(NSString*)sourceId appId:(NSString*)appId type:(int)type success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"sourceId"  : [CommTool safeString:sourceId],
                             @"appId"     : [CommTool safeString:appId],
                             @"type"      : @(type),
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-register/getServiceAgreement") params:params success:success failure:failure];
}

#pragma mark - 帐号登录相关接口

/**
 账号登录
 */
+ (void)loginWithParams:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure
{
    [self postShowToastWithURL:kUrl(@"gamesdk-login/playerLogin") params:params success:success failure:failure];
}

/**
 账号验证接口
 */
+ (void)checkAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"account"    : [CommTool safeString:account],
                             @"password"   : [CommTool safeString:password],
                             @"token"      : [CommTool safeString:token],
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-login/playerAccountCheck") params:params success:success failure:failure];
}

/**
 账号登录验证接口
 */
+ (void)checkAccountLoginStateWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"account"    : [CommTool safeString:account],
                             @"password"   : [CommTool safeString:password],
                             @"token"      : [CommTool safeString:token],
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-login/playerLoginCheck") params:params success:success failure:failure];
}

/**
 账号注销接口
 */
+ (void)logoutWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token gameCode:(NSString*)gameCode success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"account"    : [CommTool safeString:account],
                             @"password"   : [CommTool safeString:password],
                             @"token"      : [CommTool safeString:token],
                             @"gameCode"   : [CommTool safeString:gameCode],
                             };
    [self postShowToastWithURL:kUrl(@"gamesdk-login/playerLogout") params:params success:success failure:failure];
}

#pragma mark - 支付相关接口
/**
 订单创建接口
 */
+ (void)createOrderNO:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure
{
    [self postRetStringShowToastWithURL:kUrl(@"gamesdk-pay/createOrder") params:params success:success failure:failure];
}

/**
 三方查询订单支付订单状态接口 (支付宝或者微信在支付流程完成后查询订单是否支付成功或失败)
 */
+ (void)tradeQuery:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure
{
    [self postKeyValueShowToastWithURL:kUrl(@"gamesdk-pay/tradeQuery") params:params success:success failure:failure];
}

/**
 内购订单创建接口
 */
+ (void)createOrderNOForIAP:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;
{
    [self postRetStringShowToastWithURL:kUrl(@"gamesdk-pay/createOrderForIOS") params:params success:success failure:failure];
}

/**
 内购验证凭据接口
 */
+ (void)checkIapReceipt:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure
{
    [self postWithURL:kUrl(@"gamesdk-pay/verifyPaymentInfo") params:params success:success failure:failure];
}

#pragma mark - 打点接口
/**
 打点
 */
+ (void)dataReportWithType:(NSInteger)type info:(NSString*)info body:(NSString*)body success:(successBlock)success failure:(failureBlock)failure
{
    NSDictionary* params = @{
                             @"type"       : @(type),
                             @"info"       : [CommTool safeString:info],
                             @"body"       : [CommTool safeString:body],
                             };
    [self postWithURL:kUrl(@"gamesdk-data-record/addData") params:params success:success failure:failure];
}
@end

