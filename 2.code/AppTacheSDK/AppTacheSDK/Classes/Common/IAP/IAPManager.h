//
//  IAPManager.h
//  IAPDemo
//
//  Created by Charles.Yao on 2016/10/31.
//  Copyright © 2016年 com.pico. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, IAPFiledCode) {
    /**
     *  苹果返回错误信息
     */
    IAP_FILEDCOED_APPLECODE = 0,
    
    /**
     *  用户禁止应用内付费购买
     */
    IAP_FILEDCOED_NORIGHT = 1,
    
    /**
     *  商品为空
     */
    IAP_FILEDCOED_EMPTYGOODS = 2,
    
    /**
     *  无法获取产品信息，请重试
     */
    IAP_FILEDCOED_CANNOTGETINFORMATION = 3,
    
    /**
     *  购买失败，请重试
     */
    IAP_FILEDCOED_BUYFILED = 4,
    
    /**
     *  用户取消交易
     */
    IAP_FILEDCOED_USERCANCEL = 5,
    
    /**
     *  未知错误
     */
    IAP_FILEDCOED_UNKNOW = 10000,
};


@protocol IApRequestResultsDelegate <NSObject>

- (void)failedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error orderInfo:(NSDictionary*)orderInfo; //失败

- (void)successWithReceipt:(NSDictionary *)receiptDict; //成功

@end

@interface IAPManager : NSObject

SingleH

@property (nonatomic, weak)id<IApRequestResultsDelegate>delegate;

/**
 启动工具
 */
- (void)startManager;

/**
 结束工具
 */
- (void)stopManager;

/**
 请求商品列表
 */
- (void)requestProductWithId:(NSString *)productId orderId:(NSString*)orderId account:(NSString*)account cpOrderId:(NSString*)cpOrderId price:(NSString*)price extInfo:(NSString*)extInfo;

/**
 支付成功后移除本地保存的receipt
 */
- (void)removeReceipt;


@end
