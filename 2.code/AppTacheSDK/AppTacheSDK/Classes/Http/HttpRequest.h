//
//  HttpRequest.h
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FJNetworkStatusType) {
    /// 未知网络
    FJNetworkStatusUnknown,
    /// 无网络
    FJNetworkStatusNotReachable,
    /// 手机网络
    FJNetworkStatusReachableViaWWAN,
    /// WIFI网络
    FJNetworkStatusReachableViaWiFi
};

typedef void(^successBlock)(id retObj);
typedef void(^failureBlock)(NSError* error);
typedef void(^FJNetworkStatusBlock)(FJNetworkStatusType networkStatus);

@interface HttpRequest : NSObject

#pragma mark - 统一请求接口

/**
 GET请求
 */
+ (void)getWithURL:(NSString*)url success:(successBlock)success failure:(failureBlock)failure;

/**
 GET请求带菊花
 */
+ (void)getShowToastWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求
 */
+ (void)postWithURL:(NSString*)url params:(NSDictionary*)params success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求, 回调字符串
 */
+ (void)postRetStringWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求带菊花
 */
+ (void)postShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求带菊花, 回调字符串
 */
+ (void)postRetStringShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 POST请求带菊花, 字典形参
 */
+ (void)postKeyValueShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure;

/**
 取消请求
 */
+ (void)cancel;

#pragma mark - 网络状态相关接口

///**
// 监听网络状态
// */
//+ (void)networkStatusWithBlock:(FJNetworkStatusBlock)networkStatusBlock;
//
///**
// 有网YES, 无网:NO
// */
//+ (BOOL)isNetwork;
//
///**
// 手机网络:YES, 反之:NO
// */
//+ (BOOL)isWWANNetwork;
//
///**
// WiFi网络:YES, 反之:NO
// */
//+ (BOOL)isWiFiNetwork;

@end
