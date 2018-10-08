//
//  Utils.h
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utils : NSObject

#pragma mark - 设备信息相关
+ (NSString *)getModel; //设备型号 比如iphone几代
+ (NSString *)getVersion; //ios系统版本号 比如ios7.0.3
+ (NSString *)getResolution; //屏幕分辨率
+ (NSString *)getDeviceIdentifier; //设备唯一标识
+ (NSString *)getDeviceResolution; //设备分辨率
+ (NSString *)getDeviceLanguage;
+ (NSString *)getDeviceOperators;
+ (NSString *)getNetwork;
+ (NSString *)md5:(NSString *) input;

+ (BOOL)startWith:(NSString*)prefix forString:(NSString*)text;

#pragma mark - 账号保存相关

+ (void)addGuestContent:(NSString *)username password:(NSString *)password refreshToken:(NSString *)refreshToken time:(NSString *)time;
+ (void)addContent:(NSString *)username refreshToken:(NSString *)refreshToken time:(NSString *)time password:(NSString*)password;
+ (void)addCurContent:(NSString *)username password:(NSString *)password refreshToken:(NSString *)refreshToken time:(NSString *)time;
+ (void)setContentExpired:(NSString *)username;
+ (NSDictionary*)getGuestUser;
+ (NSDictionary*)getContentByIndex:(NSInteger)index;
+ (NSMutableArray*)getAllUsers;
+ (NSDictionary*)getCurUser;
+ (void)removeCurContent:(NSString*)name;
+ (void)removeContentByIndex:(NSInteger)index;
+ (void)removeContentByUsername:(NSString *)name;

@end
