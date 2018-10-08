//
//  HYBJsObjCModel.h
//  AppTache
//
//  Created by admin on 18/7/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JavaScriptObjectiveCDelegate.h"

@protocol HYBJsObjCModelDelegate;

// 此模型用于注入JS的模型，这样就可以通过模型来调用方法。
@interface HYBJsObjCModel : NSObject <JavaScriptObjectiveCDelegate>

//@property (nonatomic, weak) JSContext *jsContext;
//@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) id<HYBJsObjCModelDelegate> delegate;

@end

@protocol HYBJsObjCModelDelegate <NSObject>

- (void)hybModelQuitBack;

- (void)hybModelGetOrderId:(NSString*)orderId;

@end
