//
//  BaseModel.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+ (instancetype)fj_objectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (NSDictionary *)fj_dictionaryRepresentation
{
    unsigned int count = 0;
    //get a list of all properties of this class
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    NSDictionary *keyValueMap = [self fj_attributeMapDictionary];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        NSLog(@"key = %@, value = %@, value class = %@, changed Key = %@", key, value, NSStringFromClass([value class]), [keyValueMap objectForKey:key]);
        key = [keyValueMap objectForKey:key];
        //only add it to dictionary if it is not nil
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

/**
 属性名和json名对应
 */
- (NSDictionary *)fj_attributeMapDictionary
{
    //子类需要重写的方法
    //NSAssert(NO, "You should override this method in Your Custom Class");
    return nil;
}

// 过滤模型中不存在的key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    DLog(@"key:%@ value:%@ is not in model !", key, value);
}

@end
