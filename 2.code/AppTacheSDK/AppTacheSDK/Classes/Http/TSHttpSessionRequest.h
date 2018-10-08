//
//  TSHttpSessionRequest.h
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SessionBlock)(NSData* data, NSURLResponse* response, NSError* error);

@interface TSHttpSessionRequest : NSObject

+ (void)sessionRequestDataTask:(NSString *)url andMethod:(NSString*)method andDataStr:(NSString *)pdata andblock:(SessionBlock)block;

+ (void)sessionRequestDataTask:(NSString *)url andMethod:(NSString*)method andDictData:(NSDictionary *)params andblock:(SessionBlock)block;

@end
