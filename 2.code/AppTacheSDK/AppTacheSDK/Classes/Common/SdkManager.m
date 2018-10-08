//
//  SdkManager.m
//  AppTache
//
//  Created by admin on 2018/9/19.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "SdkManager.h"

#import "TSGameCenterToolbarView.h"
#import "TSAccountViewController.h"
#import "TSLoginModel.h"
#import "TSPayViewController.h"
#import "IQKeyboardManager.h"
#import "TSAppstorePay.h"

@interface SdkManager() <TSGameCenterToolbarViewDelegate, TSAppstorePayDelegate>
{
    BOOL _isInitIAP;
}

@property (nonatomic, strong)TSGameCenterToolbarView* toolBarView;
@property (nonatomic, copy)NSString* serialNo;
@property (nonatomic, strong)NSDictionary* deviceInfo;
@property (nonatomic, strong)NSDictionary* tradeInfo;  //记录传进来支付参数

@end

@implementation SdkManager

SingleM

#pragma mark - SDK网络接口

- (void)sdkInit
{
    // 开启自动键盘适应
    [IQKeyboardManager sharedManager].enable = YES;
    // 键盘弹出时，点击背景，键盘收回
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    _isInitIAP = NO;
}

// 获取手机验证码
- (void)sdkGetVerfyCodeWithPhone:(NSString*)phone
{
    WEAKSELF
    [HttpTool getVerificationCodeWithPhone:phone type:@"0" success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        strongSelf.serialNo = [retObj objectForKey:@"serialNo"];
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
    }];
}

// 用户注册协议
- (void)sdkShowUserProtocol:(UIViewController*)presentVC
{
    TSWebViewController* webVC = [TSWebViewController new];
    webVC.urlString = kUrlUserProtocol;
    webVC.title = @"用户协议";
    
    TSNavigationController* navVC = [[TSNavigationController alloc] initWithRootViewController:webVC];
//    UIViewController* vc = [CommTool getCurrentWindowRootVC];
    [presentVC presentViewController:navVC animated:YES completion:nil];
}

// 手机注册
- (void)sdkRegisterWithPhone:(NSString*)phone verifyCode:(NSString*)code success:(SuccessBlock)success
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"account"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:code forKey:@"verificationCode"];
    [params setObject:self.serialNo forKey:@"serialNo"];
    [params setObject:FJTextSDKInitPwd forKey:@"password"];
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [params setObject:@1 forKey:@"type"]; // 手机注册
    
    WEAKSELF
    [HttpTool registerWithParams:params success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            TSLoginModel* loginResult = [TSLoginModel fj_objectWithDictionary:retObj];
            if (loginResult.isSuccess) {
                [TSLoginModel shareInstance].password = FJTextSDKInitPwd;
                [CommTool showStaus:loginResult.msg withType:TSMessageTypeInfo];
                
                [strongSelf registSuccess:success];
            } else {
                [CommTool showStaus:loginResult.msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"注册失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"注册失败，检查网络" withType:TSMessageTypeError];
    }];
}

// 登录
- (void)sdkLogin:(NSString*)username password:(NSString*)password success:(SuccessBlock)success
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:username forKey:@"account"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"" forKey:@"token"];
    [params setObject:@"" forKey:@"phone"];
    [params setObject:@"wifi" forKey:@"network"];
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [params setObject:@0 forKey:@"type"]; // 固定值
    
    WEAKSELF
    [HttpTool loginWithParams:params success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            TSLoginModel* loginResult = [TSLoginModel fj_objectWithDictionary:retObj];
            if (loginResult.isSuccess) {
                [TSLoginModel shareInstance].password = password;
                [CommTool showStaus:loginResult.msg withType:TSMessageTypeInfo];
                
                [strongSelf _loginSuccess:success];
                if ([strongSelf.delegate respondsToSelector:@selector(sdkManagerDidLoginSuccess:)]) {
                    [strongSelf.delegate sdkManagerDidLoginSuccess:retObj];
                }
            } else {
                [CommTool showStaus:loginResult.msg withType:TSMessageTypeError];
                NSDictionary* dict = @{
                                       @"success" : @(loginResult.isSuccess),
                                       @"msg" : [CommTool safeString:loginResult.msg]
                                       };
                if ([strongSelf.delegate respondsToSelector:@selector(sdkManagerDidLoginFail:)]) {
                    [strongSelf.delegate sdkManagerDidLoginFail:dict];
                }
            }
        } else {
            [CommTool showStaus:@"登录失败" withType:TSMessageTypeError];
            NSDictionary* dict = @{
                                   @"success" : @0,
                                   @"msg" : @"登录失败，返回数据错误"
                                   };
            if ([strongSelf.delegate respondsToSelector:@selector(sdkManagerDidLoginFail:)]) {
                [strongSelf.delegate sdkManagerDidLoginFail:dict];
            }
        }
    } failure:^(NSError *error) {
        STRONGSELF
        DLog(@"error=%@", error);
        [CommTool showStaus:@"登录失败，检查网络" withType:TSMessageTypeError];
        NSDictionary* dict = @{
                               @"success" : @0,
                               @"msg" : @"登录失败，网络错误"
                               };
        if ([strongSelf.delegate respondsToSelector:@selector(sdkManagerDidLoginFail:)]) {
            [strongSelf.delegate sdkManagerDidLoginFail:dict];
        }
    }];
}

// 游客登录
- (void)sdkTouristLoginSuccess:(SuccessBlock)success
{
    WEAKSELF
    [HttpTool getAccountSuccess:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            DLog(@"%@", msg);
            if (isSuccess) {
                [strongSelf _oneKeyRegisterWithAccount:dict[@"playerAccount"] success:success];
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"登录失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"err=%@", error);
        [CommTool showStaus:@"登录失败，检查网络" withType:TSMessageTypeError];
    }];
}

// 一键注册
- (void)_oneKeyRegisterWithAccount:(NSString*)account success:(SuccessBlock)success
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:account forKey:@"account"];
    [params setObject:FJTextSDKInitPwd forKey:@"password"];
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [params setObject:@0 forKey:@"type"]; // 0-快速注册  1-手机注册
    
    WEAKSELF
    [HttpTool registerWithParams:params success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            TSLoginModel* loginResult = [TSLoginModel fj_objectWithDictionary:retObj];
            if (loginResult.isSuccess) {
                [TSLoginModel shareInstance].password = FJTextSDKInitPwd;
//                [CommTool showStaus:@"游客登录成功" withType:TSMessageTypeInfo];
                
                [strongSelf registSuccess:success];
            } else {
                [CommTool showStaus:@"游客登录失败" withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"游客登录失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"游客登录失败，检查网络" withType:TSMessageTypeError];
    }];
}

// 获取账号信息
- (void)sdkGetAccountInfo
{
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* password = [TSLoginModel shareInstance].password;
    NSString* token = [TSLoginModel shareInstance].token;
    
    [self sdkGetAccountInfoWithAccount:account password:password token:token success:nil];
}

// 获取账号信息
- (void)sdkGetAccountInfoWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(SuccessBlock)success
{
    [HttpTool getAccountInfoWithAccount:account password:password token:token success:^(id retObj) {
        DLog(@"retObj=%@", retObj);
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            
            if (isSuccess) {
                NSString* json = dict[@"account"];
                NSDictionary* accountDict = [NSDictionary dictionaryWithJsonString:json];
                NSString* accountRet = accountDict[@"account"];
                //获取账号信息（登录状态）
                if ([accountRet isEqualToString:account]) {
                    [TSLoginModel shareInstance].phone = accountDict[@"phone"];
                }
                
                //忘记密码调用（注销状态）
                if ([TSLoginModel shareInstance].account == nil ||
                    [[TSLoginModel shareInstance].account isEqualToString:@""]) {
                    [TSLoginModel shareInstance].phone = accountDict[@"phone"];
                    [TSLoginModel shareInstance].account = accountRet;
                }
                
                if (success) {
                    success();
                }
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"登录失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"获取账号信息失败，检查网络" withType:TSMessageTypeError];
    }];
}

// 绑定账号
- (void)sdkBindAccount:(NSString*)account password:(NSString*)password token:(NSString *)token phone:(NSString *)phone verificationCode:(NSString *)code success:(SuccessBlock)success
{
    [HttpTool bindAccount:account password:password token:token phone:phone verificationCode:code serialNo:self.serialNo success:^(id retObj) {
        DLog(@"retObj=%@", retObj);
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            
            if (isSuccess) {
                [TSLoginModel shareInstance].phone = phone;
                [CommTool showStaus:msg withType:TSMessageTypeInfo];
                
                if (success) {
                    success();
                }
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"绑定失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"绑定账号失败，检查网络" withType:TSMessageTypeError];
    }];
}

// 解绑账号
- (void)sdkUnBindAccount:(NSString*)account password:(NSString*)password token:(NSString *)token phone:(NSString *)phone verificationCode:(NSString *)code success:(SuccessBlock)success
{
    [HttpTool unbindAccount:account password:password token:token phone:phone verificationCode:code serialNo:self.serialNo success:^(id retObj) {
        DLog(@"retObj=%@", retObj);
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            
            if (isSuccess) {
                [TSLoginModel shareInstance].phone = @"";
                [CommTool showStaus:msg withType:TSMessageTypeInfo];
                
                if (success) {
                    success();
                }
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"解绑失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"解绑账号失败，检查网络" withType:TSMessageTypeError];
    }];
}

- (void)sdkModifyPasswordWithAccount:(NSString*)account oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode success:(SuccessBlock)success
{
    [self _modifyPasswordWithType:1 account:account oldPwd:oldPwd password:password token:token verificationCode:verificationCode success:success];
}

- (void)sdkFindPasswordWithAccount:(NSString*)account oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode success:(SuccessBlock)success
{
    [self _modifyPasswordWithType:0 account:account oldPwd:oldPwd password:password token:token verificationCode:verificationCode success:success];
}

- (void)_modifyPasswordWithType:(NSInteger)type account:(NSString*)account oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode success:(SuccessBlock)success
{
    [HttpTool modifyPasswordWithAccount:account type:type oldPwd:oldPwd password:password token:token verificationCode:verificationCode serialNo:self.serialNo success:^(id retObj) {
        DLog(@"retObj=%@", retObj);
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            
            if (isSuccess) {
                NSString* pwd = dict[@"password"];
                NSString* token = dict[@"token"];
                
                [TSLoginModel shareInstance].password = pwd;
                [TSLoginModel shareInstance].token = token;
                
                [CommTool showStaus:msg withType:TSMessageTypeInfo];
                
                if (success) {
                    success();
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationFindPasswordSuccess" object:nil];
                
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"修改密码失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"修改密码失败，检查网络" withType:TSMessageTypeError];
    }];
}

- (void)sdkLogout:(SuccessBlock)success
{
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* password = [TSLoginModel shareInstance].password;
    NSString* token = [TSLoginModel shareInstance].token;
    NSString* gameCode = [TSAppModel shareInstance].gameCode;
    
    WEAKSELF
    [HttpTool logoutWithAccount:account password:password token:token gameCode:gameCode success:^(id retObj) {
        STRONGSELF
        NSDictionary* dict = retObj;
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [dict[@"success"] boolValue];
            NSString* msg = dict[@"msg"];
            if (isSuccess) {
                [CommTool showStaus:@"注销成功" withType:TSMessageTypeInfo];
                [strongSelf _logoutSuccess:success];
                
                if ([strongSelf.delegate respondsToSelector:@selector(sdkManagerDidLogoutSuccess:)]) {
                    [strongSelf.delegate sdkManagerDidLogoutSuccess:retObj];
                }
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
        } else {
            [CommTool showStaus:@"注销失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"注销失败，检查网络" withType:TSMessageTypeError];
    }];
}

- (void)registSuccess:(SuccessBlock)success
{
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* password = [TSLoginModel shareInstance].password;
    
    [self sdkLogin:account password:password success:^{
        if (success) {
            success();
        }
    }];
}

- (void)_loginSuccess:(SuccessBlock)success
{
    if (success) {
        success();
    }
    [self sdkShowFloatView];
    
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* password = [TSLoginModel shareInstance].password;
    NSString* token = [TSLoginModel shareInstance].token;
    
    [Utils addCurContent:account password:password refreshToken:token time:[CommTool getTimeStamp]];
    [Utils addContent:account refreshToken:token time:[CommTool getTimeStamp] password:password];
}

- (void)_logoutSuccess:(SuccessBlock)success
{
    if (success) {
        success();
    }
    [[TSLoginModel shareInstance] clear];
    
    [self removeFloatView];
    
    //内购
    if ([TSLoginModel shareInstance].payType == 0) {
        [self _stopIAPstore];
        _isInitIAP = NO;
    }
}

- (void)sdkRequestPay:(NSDictionary*)paramsTemp success:(SuccessBlock)success
{
    self.tradeInfo = paramsTemp;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:paramsTemp];
    [params setObject:[TSAppModel shareInstance].platformId forKey:@"platform"];
    [params setObject:[TSAppModel shareInstance].gameCode forKey:@"gameCode"];
    
    [params setObject:[TSLoginModel shareInstance].account forKey:@"account"];
    [params setObject:[TSLoginModel shareInstance].token forKey:@"token"];
    [params setObject:[TSLoginModel shareInstance].password forKey:@"password"];
    
    [params setObject:@"0" forKey:@"imei"];
    [params setObject:@"0" forKey:@"imsi"];
    [params setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [params setObject:@0 forKey:@"type"]; // 固定值
    
    DLog(@"pay params = %@", params);
    
    //内购
    if ([TSLoginModel shareInstance].payType == 0) {
        
        // 调用一次防止游戏没有调用进入游戏打点接口
        [self _initIAPstore];

        [params setObject:@"applepay" forKey:@"payMethodCode"];
        
        [HttpTool createOrderNOForIAP:params success:^(id retObj) {
            DLog(@"retObj=%@", retObj);
            NSDictionary* retDict = nil;
            if (retObj && [retObj isKindOfClass:[NSString class]]) {
                retDict = [NSDictionary dictionaryWithJsonString:retObj];
            } else if(retObj && [retObj isKindOfClass:[NSDictionary class]]) {
                retDict = retObj;
            } else {
                [CommTool showStaus:@"创建订单失败，数据格式错误" withType:TSMessageTypeError];
                return;
            }
            
            NSString* succ = retDict[@"success"];
            BOOL isSuccess = [succ boolValue];
            NSString* msg = retDict[@"msg"];
            
            if (isSuccess) {
                NSString* orderId = retDict[@"orderId"];
                [params setObject:orderId forKey:@"orderId"];
                
                [[TSAppstorePay shareInstace] SDKWorkWithParams:params];
            } else {
                [CommTool showStaus:msg withType:TSMessageTypeError];
            }
            
        } failure:^(NSError *error) {
            DLog(@"error=%@", error);
            [CommTool showStaus:@"创建订单失败，检查网络" withType:TSMessageTypeError];
        }];
        
    } else { //三方
        
        [HttpTool createOrderNO:params success:^(id retObj) {
            //DLog(@"retObj=%@", retObj);
            //返回的retObj为html字符串
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPayWebView:retObj];
            });
        } failure:^(NSError *error) {
            DLog(@"error=%@", error);
            [CommTool showStaus:@"创建订单失败，检查网络" withType:TSMessageTypeError];
        }];
    }
}

- (void)sdkThirdTradeQuery:(NSString*)orderId
{
    NSDictionary* params = @{ @"orderId" : orderId };
    WEAKSELF
    [HttpTool tradeQuery:params success:^(NSDictionary* retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        if (retObj && [retObj isKindOfClass:[NSDictionary class]]) {
            BOOL isSuccess = [retObj[@"success"] boolValue];
            NSString* msg = retObj[@"msg"];
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:retObj];
            [dict setObject:orderId forKey:@"orderId"];
            
            NSDictionary* finalResult = [strongSelf tradeResultAddInfo:dict];
            
            if (isSuccess) {
                [CommTool showStaus:msg withType:TSMessageTypeInfo];
                
                [strongSelf tradeSuccess:finalResult];
            } else {
                [CommTool showStaus:@"支付失败" withType:TSMessageTypeError];
                
                [strongSelf tradeFail:finalResult];
            }
        } else {
            [CommTool showStaus:@"查询订单失败" withType:TSMessageTypeError];
        }
    } failure:^(NSError *error) {
        DLog(@"error=%@", error);
        [CommTool showStaus:@"查询订单失败，检查网络" withType:TSMessageTypeError];
    }];
}

- (void)showPayWebView:(NSString*)htmlString
{
    DLog();
    
    if (htmlString == nil) {
        return;
    }
    
    TSPayViewController* webView = [TSPayViewController new];
    webView.htmlString = htmlString;
    webView.title = @"支付";
    
    TSNavigationController* navVC = [[TSNavigationController alloc] initWithRootViewController:webView];
    
    [[CommTool getCurrentWindowRootVC] presentViewController:navVC animated:YES completion:nil];
    
    // 开启支付页面，隐藏悬浮窗（不能同时弹出账号和支付页面）
    [[SdkManager shareInstance] sdkHideFloatView];
}

// 显示悬浮窗
- (void)sdkShowFloatView
{
    DLog();
    
    if ([NSThread currentThread].isMainThread) {
        [self _showFloatView];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showFloatView];
        });
    }
}

- (void)_showFloatView
{
    if (_toolBarView) {
        _toolBarView.hidden = NO;
        return;
    }
    
    TSGameCenterToolbarView* toolBarView = [[TSGameCenterToolbarView alloc] init];
    [toolBarView initView];
    toolBarView.hidden = NO;
    toolBarView.delegate = self;
    UIWindow *window = [CommTool getCurrentWindow];
    [window addSubview:toolBarView];
    [window bringSubviewToFront:toolBarView];
    
    _toolBarView = toolBarView;
}

// 隐藏悬浮窗
- (void)sdkHideFloatView
{
    DLog();
    
    if (!self.toolBarView) {
        return;
    }
    
    if ([NSThread currentThread].isMainThread) {
        self.toolBarView.hidden = YES;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.toolBarView.hidden = YES;
        });
    }
}

// 隐藏悬浮窗
- (void)removeFloatView
{
    DLog();
    
    if (!self.toolBarView) {
        return;
    }
    
    if ([NSThread currentThread].isMainThread) {
        [self.toolBarView removeFromSuperview];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolBarView removeFromSuperview];
            self.toolBarView = nil;
        });
    }
}

- (void)_initIAPstore
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    
    if (_isInitIAP == NO) {
        
        DLog(@"======");
    
        [[TSAppstorePay shareInstace] setDelegate:self];
        [[TSAppstorePay shareInstace] initialStorePay];
    
        _isInitIAP = YES;
    }
        
//    });
}

- (void)_stopIAPstore
{
    [[TSAppstorePay shareInstace] stopStorePay];
}

#pragma mark - 数据打点

- (void)sdkDataActive:(NSDictionary*)params success:(SuccessBlock)success
{
    [self dataReportWithType:1 params:params success:^{
        DLog(@"actice success");
        if (success) {
            success();
        }
    }];
}

- (void)sdkDataCreateRole:(NSDictionary*)params success:(SuccessBlock)success
{
    [self dataReportWithType:12 params:params success:^{
        DLog(@"create role success");
        if (success) {
            success();
        }
    }];
}

- (void)sdkDataEnterGame:(NSDictionary*)params success:(SuccessBlock)success
{
    [self dataReportWithType:13 params:params success:^{
        DLog(@"enter game success");
        if (success) {
            success();
        }
    }];
    
    // 进入游戏初始化内购
    if ([TSLoginModel shareInstance].payType == 0 && _isInitIAP == NO) {
        [self _initIAPstore];
    }
}

- (void)sdkDataLevelUp:(NSDictionary*)params success:(SuccessBlock)success
{
    [self dataReportWithType:14 params:params success:^{
        DLog(@"leveup success");
        if (success) {
            success();
        }
    }];
}

// type数据类型，1：初始化；12：创角；13：角色登录；14：等级变化；
- (void)dataReportWithType:(NSInteger)type params:(NSDictionary*)params success:(SuccessBlock)success
{
    NSString* info = [NSString stringJsonFromDictionary:self.deviceInfo];
    NSString* body = @"{}";
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:[CommTool safeString:[TSLoginModel shareInstance].fid] forKey:@"fid"];
        body = [NSString stringJsonFromDictionary:dict];
    }
    
    DLog(@"type = %ld", (long)type);
    DLog(@"info = %@", info);
    DLog(@"body = %@", body);
    
    [HttpTool dataReportWithType:type info:info body:body success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
    }];
}

- (NSDictionary *)deviceInfo
{
    if (_deviceInfo) {
        return _deviceInfo;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    NSString* phone    = [CommTool safeString:[TSLoginModel shareInstance].phone];
    NSString* platform = [CommTool safeString:[TSAppModel shareInstance].platformId];
    NSString* gameCode = [CommTool safeString:[TSAppModel shareInstance].gameCode];
    
    [dict setObject:phone     forKey:@"phone"];
    [dict setObject:platform  forKey:@"platform"];
    [dict setObject:gameCode  forKey:@"gameCode"];
    [dict setObject:@"0" forKey:@"imei"];
    [dict setObject:@"0" forKey:@"imsi"];
    [dict setObject:@"0" forKey:@"iccid"];
    [dict setObject:[CommTool safeString:[Utils getDeviceIdentifier]] forKey:@"deviceId"];
    [dict setObject:@"Apple"  forKey:@"manufactor"];
    [dict setObject:[Utils getResolution] forKey:@"resolution"];
    [dict setObject:[Utils getVersion]    forKey:@"os"];
    [dict setObject:[Utils getModel] forKey:@"model"];

    _deviceInfo = [dict copy];
    
    return _deviceInfo;
}

#pragma mark - GameCenterToolbarViewDelegate
- (void)floatView:(TSGameCenterToolbarView *)floatView didClickMenuAccount:(id)sender
{
    DLog();
    
    TSAccountViewController* accountVC = [TSAccountViewController new];
    TSNavigationController* navVC = [[TSNavigationController alloc] initWithRootViewController:accountVC];
    
    [[CommTool getCurrentWindowRootVC] presentViewController:navVC animated:YES completion:nil];
    [self sdkHideFloatView];
}


#pragma mark - web trade back

- (void)tradeSuccess:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(sdkManagerDidPaySuccess:)]) {
        [_delegate sdkManagerDidPaySuccess:result];
    }
}

- (void)tradeFail:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(sdkManagerDidPayFail:)]) {
        [_delegate sdkManagerDidPayFail:result];
    }
}

- (void)tradeCancel:(NSDictionary*)result
{
//    NSDictionary* finalResult = [self tradeResultAddInfo:result];
    
    if ([_delegate respondsToSelector:@selector(sdkManagerDidPayCancel:)]) {
        [_delegate sdkManagerDidPayCancel:result];
    }
}

// 三方支付拼接cpOder信息，内购由上层返回
- (NSDictionary*)tradeResultAddInfo:(NSDictionary*)result
{
    NSMutableDictionary* dictRst = nil;
    if (result && [result isKindOfClass:[NSDictionary class]]) {
        dictRst = [NSMutableDictionary dictionaryWithDictionary:result];
    } else {
        dictRst = [NSMutableDictionary dictionary];
    }
    NSString* cpNo = self.tradeInfo[@"cpOrderNo"];
    NSString* extInfo = self.tradeInfo[@"extInfo"];
    
    [dictRst setObject:[CommTool safeString:cpNo] forKey:@"cpOrderNo"];
    [dictRst setObject:[CommTool safeString:extInfo] forKey:@"extInfo"];
    
    return [dictRst copy];
}

#pragma mark - TSAppstorePayDelegate

- (void)TSAppPaySuccessCallBack:(NSDictionary *)result
{
    [self tradeSuccess:result];
}

- (void)TSAppPayFailCallBack:(NSDictionary *)result
{
    [self tradeFail:result];
}

- (void)TSAppPayCancelCallBack:(NSDictionary *)result
{
    [self tradeCancel:result];
}

- (void)TSAppPayClosePayPage:(NSDictionary *)result
{
    [self tradeCancel:result];
}

@end
