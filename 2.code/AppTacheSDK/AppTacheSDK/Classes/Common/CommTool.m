//
//  CommTool.m
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "CommTool.h"



@implementation CommTool

/**
 安全化字符串，nil转为@""
 */
+ (NSString *)safeString:(NSString *)srcString
{
    return srcString==nil ? @"" : srcString;
}

/**
 *  获取当前的keyWindow
 */
+ (UIWindow*)getCurrentWindow
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    if (window && window.windowLevel == UIWindowLevelNormal) {
        return window;
    }
    
    NSArray* windows = [[UIApplication sharedApplication] windows];
    for (UIWindow* w in windows) {
        if (w.windowLevel == UIWindowLevelNormal) {
            window = w;
            break;
        }
    }
    
    return window;
}

/**
 *  获取当前keyWindow的rootViewController
 */
+ (UIViewController*)getCurrentWindowRootVC
{
    return [self getCurrentWindow].rootViewController;
}

/**
 *  提示状态消息
 */
+ (void)showStaus:(NSString*)message withType:(TSMessageType)type
{
    if ([[NSThread currentThread] isMainThread]) {
        [self showMessage:message withType:type];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showStaus:message withType:type];
        });
    }
}

/**
 *  提示状态消息
 */
+ (void)showMessage:(NSString*)message withType:(TSMessageType)type
{
    if ([message isNullString]) {
        return;
    }
    
//    static BOOL bShowStatus = NO;
//
//    if (bShowStatus) {
//        DLog(@"正在显示消息。。。");
//        return;
//    }
//    
//    bShowStatus = YES;
    
    // 1.创建一个UILabel
    UILabel *label = [[UILabel alloc] init];
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    
    // 2.显示文字
    label.text = message;
    
    // 3.设置背景
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.alpha = 0.8;
    
    // 延迟delay秒后，再执行动画
    CGFloat delay = 1.0;
    
    switch (type) {
        case TSMessageTypeInfo:
            label.backgroundColor = FJRGBColor(0, 130, 188);
            delay = 1.0;
            break;
        case TSMessageTypeError:
            label.backgroundColor = FJColorRed;
            delay = 1.3;
            break;
        case TSMessageTypeWarnning:
            label.backgroundColor = FJColorLoginOrange;
            delay = 1.0;
            break;
        default:
            label.backgroundColor = FJRGBColor(0, 130, 188);
            break;
    }
    
    UIWindow* window = [self getCurrentWindow];
    
    // 4.设置frame
    if (kScreenWidth < kScreenHeight) {
        label.fj_width = window.fj_width * 0.8;
    } else {
        label.fj_width = window.fj_width * 0.6;
    }
    label.fj_height = 54;
    label.fj_centerX = window.fj_centerX;
    label.fj_centerY = 0 - label.fj_height * 0.5;
    
    // 5.添加到导航控制器的view
    [window addSubview:label];
    
    // 6.动画
    CGFloat duration = 0.4;
    //    label.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        // 往下移动一个label的高度
        label.transform = CGAffineTransformMakeTranslation(0, label.fj_height);
        //        label.alpha = 1.0;
    } completion:^(BOOL finished) { // 向下移动完毕
        
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // 恢复到原来的位置
            label.transform = CGAffineTransformIdentity;
            //            label.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            // 删除控件
            [label removeFromSuperview];
//            bShowStatus = NO;
        }];
    }];
}

+ (NSString *)getFilePath:(NSString *)fileName andType:(NSString*)type
{
    //    NSString *szFilename = [fileNameAndType stringByDeletingPathExtension];
    //    NSString *szFileext = [fileNameAndType pathExtension];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    
    return path;
}

+(NSString *) getTimeStamp  //启动时间戳
{
    NSDate *date = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    DLog(@"%@", timeSp);
    
    return timeSp;
}

@end
