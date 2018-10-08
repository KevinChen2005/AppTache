//
//  TSAppstorePay.h
//  funcell_framework
//
//  Created by admin on 17/6/15.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSAppstorePayDelegate;

@interface TSAppstorePay : NSObject

@property (nonatomic, weak) id<TSAppstorePayDelegate> delegate;

+(TSAppstorePay*) shareInstace;

//初始化
-(void)initialStorePay;

//充值接口
-(void)SDKWorkWithParams:(NSDictionary*)params;

//release
-(void)stopStorePay;

@end


@protocol TSAppstorePayDelegate <NSObject>

/**
 *支付成功回调
 */
- (void)TSAppPaySuccessCallBack:(NSDictionary*)result;

/**
 *渠道回调支付失败回调
 */
- (void)TSAppPayFailCallBack:(NSDictionary*)result;

/**
 *渠道回调支付取消回调
 */
- (void)TSAppPayCancelCallBack:(NSDictionary*)result;

/**
 *渠道回调支付关闭界面,网络请求失败,未知错误等
 */
- (void)TSAppPayClosePayPage:(NSDictionary*)result;

@end
