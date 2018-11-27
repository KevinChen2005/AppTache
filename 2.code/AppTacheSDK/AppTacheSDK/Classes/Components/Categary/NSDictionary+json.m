//
//  NSDictionary+json.m
//  apptache
//
//  Created by admin on 17/4/27.
//  Copyright © 2017年 apptache. All rights reserved.
//

#import "NSDictionary+json.h"

@implementation NSDictionary (json)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
//    NSLog(@"解析jsonString：%@",jsonString);
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
