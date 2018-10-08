//
//  CommTool.h
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TSMessageType)
{
    TSMessageTypeInfo = 0,
    TSMessageTypeWarnning,
    TSMessageTypeError,
};

@interface CommTool : NSObject

/**
 安全化字符串，nil转为@""
 */
+ (NSString*)safeString:(NSString*)srcString;

/**
 *  获取当前的keyWindow
 */
+ (UIWindow*)getCurrentWindow;

/**
 *  获取当前keyWindow的rootViewController
 */
+ (UIViewController*)getCurrentWindowRootVC;

/**
 *  提示状态消息
 */
+ (void)showStaus:(NSString*)message withType:(TSMessageType)type;

/**
 *  获取当前时间戳
 */
+ (NSString*)getTimeStamp;

@end
