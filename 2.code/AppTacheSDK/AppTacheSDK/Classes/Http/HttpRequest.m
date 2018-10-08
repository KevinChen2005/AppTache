//
//  HttpRequest.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "HttpRequest.h"
#import "TSHttpSessionRequest.h"

@implementation HttpRequest

#pragma mark - 统一接口
/**
 GET请求
 */
+ (void)getWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [TSHttpSessionRequest sessionRequestDataTask:url andMethod:@"GET" andDataStr:@"" andblock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* dict = [NSDictionary dictionaryWithJsonString:str];
            if (success) success(dict);
        }
    }];
}

/**
 POST请求
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    NSString* paramsString = [NSString stringJsonFromDictionary:params];
    
    [TSHttpSessionRequest sessionRequestDataTask:url andMethod:@"POST" andDataStr:paramsString andblock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* dict = [NSDictionary dictionaryWithJsonString:str];
            if (success) success(dict);
        }
    }];
}

/**
 POST请求, 字典形式作为形参
 */
+ (void)postKeyValueWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [TSHttpSessionRequest sessionRequestDataTask:url andMethod:@"POST" andDictData:params andblock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* dict = [NSDictionary dictionaryWithJsonString:str];
            if (success) success(dict);
        }
    }];
}

/**
 POST请求, 回调字符串
 */
+ (void)postRetStringWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    NSString* paramsString = [NSString stringJsonFromDictionary:params];
    
    [TSHttpSessionRequest sessionRequestDataTask:url andMethod:@"POST" andDataStr:paramsString andblock:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (failure) failure(error);
        } else {
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSDictionary* dict = [NSDictionary dictionaryWithJsonString:str];
            if (success) success(str);
        }
    }];
}

/**
 GET请求带菊花
 */
+ (void)getShowToastWithURL:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMaskMessage:nil];
    
    [self getWithURL:url success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST请求带菊花
 */
+ (void)postShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMaskMessage:nil];
    
    [self postWithURL:url params:params success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST请求带菊花, 字典形参
 */
+ (void)postKeyValueShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMaskMessage:nil];
    
    [self postKeyValueWithURL:url params:params success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST请求带菊花
 */
+ (void)postRetStringShowToastWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
    [FJProgressHUB showWithMaskMessage:nil];
    
    [self postRetStringWithURL:url params:params success:^(id retObj) {
        [FJProgressHUB dismiss];
        if (success) {
            success(retObj);
        }
    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        if (failure) {
            failure(error);
        }
    }];
}

/**
 POST上传图片
 */
+ (void)uploadImageWithURL:(NSString *)url image:(UIImage*)image params:(NSDictionary *)params success:(successBlock)success failure:(failureBlock)failure
{
   
}

/**
 取消请求
 */
+ (void)cancel
{
}

#pragma mark - 开始监听网络
//+ (void)networkStatusWithBlock:(FJNetworkStatusBlock)networkStatusBlock {
//    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                networkStatusBlock ? networkStatusBlock(FJNetworkStatusUnknown) : nil;
//                DLog(@"未知网络");
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                networkStatusBlock ? networkStatusBlock(FJNetworkStatusNotReachable) : nil;
//                DLog(@"无网络");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                networkStatusBlock ? networkStatusBlock(FJNetworkStatusReachableViaWWAN) : nil;
//                DLog(@"移动数据网络");
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                networkStatusBlock ? networkStatusBlock(FJNetworkStatusReachableViaWiFi) : nil;
//                DLog(@"WIFI");
//                break;
//        }
//    }];
//}
//
//+ (BOOL)isNetwork
//{
//    return [AFNetworkReachabilityManager sharedManager].reachable;
//}
//
//+ (BOOL)isWWANNetwork
//{
//    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
//}
//
//+ (BOOL)isWiFiNetwork
//{
//    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
//}

@end
