//
//  BaseModel.h
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)dict;

+ (instancetype)fj_objectWithDictionary:(NSDictionary*)dict;

- (NSDictionary*)fj_dictionaryRepresentation;

@end
