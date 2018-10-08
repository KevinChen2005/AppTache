//
//  SdkManager.h
//  AppTache
//
//  Created by admin on 2018/9/19.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(void);

@protocol SdkManagerDelegate;

@interface SdkManager : NSObject

SingleH

@property (nonatomic, weak)id<SdkManagerDelegate> delegate;

- (void)sdkInit;

- (void)sdkShowUserProtocol:(UIViewController*)presentVC;
- (void)sdkGetVerfyCodeWithPhone:(NSString*)phone;

- (void)sdkRegisterWithPhone:(NSString*)phone verifyCode:(NSString*)code success:(SuccessBlock)success;

- (void)sdkTouristLoginSuccess:(SuccessBlock)success;
- (void)sdkLogin:(NSString*)username password:(NSString*)password success:(SuccessBlock)success;
- (void)sdkLogout:(SuccessBlock)success;

- (void)sdkGetAccountInfo;
- (void)sdkGetAccountInfoWithAccount:(NSString*)account password:(NSString*)password token:(NSString*)token success:(SuccessBlock)success;

- (void)sdkBindAccount:(NSString*)account password:(NSString*)password token:(NSString *)token phone:(NSString *)phone verificationCode:(NSString *)code success:(SuccessBlock)success;

- (void)sdkUnBindAccount:(NSString*)account password:(NSString*)password token:(NSString *)token phone:(NSString *)phone verificationCode:(NSString *)code success:(SuccessBlock)success;

- (void)sdkModifyPasswordWithAccount:(NSString*)account oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode success:(SuccessBlock)success;

- (void)sdkFindPasswordWithAccount:(NSString*)account oldPwd:(NSString*)oldPwd password:(NSString*)password token:(NSString*)token verificationCode:(NSString*)verificationCode success:(SuccessBlock)success;

- (void)sdkRequestPay:(NSDictionary*)params success:(SuccessBlock)success;
- (void)sdkThirdTradeQuery:(NSString*)orderId;

- (void)sdkShowFloatView;
- (void)sdkHideFloatView;

- (void)sdkDataActive:(NSDictionary*)params success:(SuccessBlock)success;
- (void)sdkDataCreateRole:(NSDictionary*)params success:(SuccessBlock)success;
- (void)sdkDataEnterGame:(NSDictionary*)params success:(SuccessBlock)success;
- (void)sdkDataLevelUp:(NSDictionary*)params success:(SuccessBlock)success;

@end

@protocol SdkManagerDelegate <NSObject>

- (void)sdkManagerDidLoginSuccess:(NSDictionary*)result;
- (void)sdkManagerDidLoginFail:(NSDictionary*)result;
- (void)sdkManagerDidLogoutSuccess:(NSDictionary*)result;
- (void)sdkManagerDidPaySuccess:(NSDictionary*)result;
- (void)sdkManagerDidPayFail:(NSDictionary*)result;
- (void)sdkManagerDidPayCancel:(NSDictionary*)result;

@end


