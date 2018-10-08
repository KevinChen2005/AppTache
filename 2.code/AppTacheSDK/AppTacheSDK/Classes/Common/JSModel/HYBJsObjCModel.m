//
//  HYBJsObjCModel.m
//  AppTache
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HYBJsObjCModel.h"

@implementation HYBJsObjCModel

#pragma make - JavaScriptObjectiveCDelegate 与js交互方法

// js端 app.quitBack()
- (void)quitBack
{
    if ([self.delegate respondsToSelector:@selector(hybModelQuitBack)]) {
        [self.delegate hybModelQuitBack];
    }
}

// js端 app.getOrderId(orderId)
- (void)getOrderId:(NSString*)orderId
{
    if ([self.delegate respondsToSelector:@selector(hybModelGetOrderId:)]) {
        [self.delegate hybModelGetOrderId:orderId];
    }
}

// js端 app.isInstallApp(pkgName)
- (BOOL)isInstallApp:(NSString*)pkgName
{
    // pkgName = @"weixin://"
    
    __block BOOL bInstall = NO;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_main_queue(), ^{
        bInstall = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pkgName]];
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return bInstall;
}

// js端 app.showMessage(msg)
- (void)showMessage:(NSString*)message
{
    [CommTool showStaus:message withType:TSMessageTypeInfo];
}


@end
