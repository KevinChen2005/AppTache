//
//  JavaScriptObjectiveCDelegate.h
//  AppTache
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCDelegate <JSExport>

#pragma make - 与js交互方法

// js端 app.quitBack()
- (void)quitBack;

// js端 app.getOrderId(orderId)
- (void)getOrderId:(NSString*)orderId;

// js端 app.isInstallApp(pkgName)
- (BOOL)isInstallApp:(NSString*)pkgName;

// js端 app.showMessage(msg)
- (void)showMessage:(NSString*)message;

@end
