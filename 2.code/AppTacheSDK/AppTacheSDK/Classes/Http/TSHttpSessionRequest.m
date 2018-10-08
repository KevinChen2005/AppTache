//
//  TSHttpSessionRequest.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSHttpSessionRequest.h"

@implementation TSHttpSessionRequest

+ (void)sessionRequestDataTask:(NSString *)url andMethod:(NSString*)method andDataStr:(NSString *)pdata andblock:(SessionBlock)block
{
    NSString* urlstring = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//去中文
    NSURL* sendurl = [NSURL URLWithString:urlstring];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:sendurl];
    [request setHTTPMethod:method];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request setTimeoutInterval:15];
    if ( [method isEqualToString:@"POST"] )
    {
        [request setHTTPBody:[pdata dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:block];
    [task resume];
}

+ (void)sessionRequestDataTask:(NSString *)url andMethod:(NSString*)method andDictData:(NSDictionary *)params andblock:(SessionBlock)block
{
    NSString* paramsString = @"";
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        NSArray *keysArray = [params allKeys];
        NSInteger count = keysArray.count;
        for (int i = 0; i < count; i++) {
            //根据键值处理字典中的每一项
            NSString *key = keysArray[i];
            NSString *value = params[key];
            paramsString = [paramsString stringByAppendingFormat:@"%@=%@", key, value];
            if (i<count-1) {
                paramsString = [paramsString stringByAppendingString:@"&"];
            }
        }
    }
    
    NSString* urlstring = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//去中文
    NSURL* sendurl = [NSURL URLWithString:urlstring];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:sendurl];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:15];
    if ( [method isEqualToString:@"POST"] )
    {
        [request setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:block];
    [task resume];
}

//+ (void)sessionRequestDataTask:(NSString *)url andMethod:(NSString*)method andDictData:(NSDictionary *)params andblock:(SessionBlock)block
//{
//    NSString* urlstring = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//去中文
//    NSURL* sendurl = [NSURL URLWithString:urlstring];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:sendurl];
//    [request setHTTPMethod:method];
//    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"text/html;charset=UTF-8" forHTTPHeaderField:@"Accept"];
//    [request setTimeoutInterval:15];
//    if ( [method isEqualToString:@"POST"] )
//    {
//        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
//        [request setHTTPBody:data];
//    }
//
//    NSURLSession* session = [NSURLSession sharedSession];
//    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:block];
//    [task resume];
//}

@end
