//
//  NSString+dictionary.m
//  apptache
//
//  Created by admin on 17/4/27.
//  Copyright © 2017年 apptache. All rights reserved.
//

#import "NSString+dictionary.h"

@implementation NSString (dictionary)

+ (NSString*)stringJsonFromDictionary:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
