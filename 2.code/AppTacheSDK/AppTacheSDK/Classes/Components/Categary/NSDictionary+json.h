//
//  NSDictionary+json.h
//  apptache
//
//  Created by admin on 17/4/27.
//  Copyright © 2017年 apptache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (json)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
