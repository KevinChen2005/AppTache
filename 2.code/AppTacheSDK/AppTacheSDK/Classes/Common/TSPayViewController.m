//
//  TSPayViewController.m
//  AppTache
//
//  Created by admin on 2018/9/21.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSPayViewController.h"
#import "HYBJsObjCModel.h"

@interface TSPayViewController ()<HYBJsObjCModelDelegate>
{
    BOOL _bClickDoTrade; //是否点了支付页面的确认支付按钮（如果没点返回后就不查询支付结果）
}

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *orderId;

@end

@implementation TSPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bClickDoTrade = NO;
    
    self.jsContext = [[JSContext alloc] init];
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
}

- (void)back
{
    [super back];
    [[SdkManager shareInstance] sdkShowFloatView];
    
    if (self.orderId == nil || [self.orderId isEqualToString:@""]) {
        return;
    }
    
    if (_bClickDoTrade) {
        [[SdkManager shareInstance] sdkThirdTradeQuery:_orderId];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 通过模型调用方法，这种方式更好些。
    HYBJsObjCModel *model  = [[HYBJsObjCModel alloc] init];
    model.delegate = self;
    self.jsContext[@"app"] = model;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];

    //监听一下navigationType类型即可实现
    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];
    NSLog(@"urlString = %@", urlString);
    
    // 加载zhi——fu
    NSMutableString* strA = [NSMutableString string];
    [strA appendString:@"a"];
    [strA appendString:@"l"];
    [strA appendString:@"i"];
    [strA appendString:@"p"];
    [strA appendString:@"a"];
    [strA appendString:@"y"];
    [strA appendString:@":"];
    [strA appendString:@"/"];
    [strA appendString:@"/"];
    NSMutableString* strW = [NSMutableString string];
    [strW appendString:@"w"];
    [strW appendString:@"e"];
    [strW appendString:@"i"];
    [strW appendString:@"x"];
    [strW appendString:@"i"];
    [strW appendString:@"n"];
    [strW appendString:@":"];
    [strW appendString:@"/"];
    [strW appendString:@"/"];
    
    if ([Utils startWith:strA forString:urlString] ||
        [Utils startWith:strW forString:urlString]) {
        
        _bClickDoTrade = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

            [self.webView loadRequest:request];
        });
        
        return NO;
    }
    
    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [[headers objectForKey:@"Referer"]  containsString:@"weixin.xdragonnet.com"];
    
    if (!hasReferer && [urlString containsString:@"weixin.xdragonnet.com"] && ![urlString containsString:@"alipay"]) {
        // relaunch with a modified request
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
                //                [request setHTTPMethod:@"GET"];
                [request setValue:@"weixin.xdragonnet.com://" forHTTPHeaderField: @"Referer"];
                [webView loadRequest:request];
            });
        });
        
        return NO;
    }
    
    return YES;
}

#pragma mark - HYBJsObjCModelDelegate

- (void)hybModelQuitBack
{
    [self back];
}

- (void)hybModelGetOrderId:(NSString *)orderId
{
    NSLog(@"orderId = %@", orderId);
    self.orderId = orderId;
}

//#pragma make - JavaScriptObjectiveCDelegate 与js交互方法
//
//// js端 app.quitBack()
//- (void)quitBack
//{
//    [self back];
//}
//
//// js端 app.getOrderId(orderId)
//- (void)getOrderId:(NSString*)orderId
//{
//    NSString* _orderId = orderId;
//    NSLog(@"_orderId = %@", _orderId);
//}
//
//// js端 app.isInstallApp(pkgName)
//- (BOOL)isInstallApp:(NSString*)pkgName
//{
//    // pkgName = @"weixin://"
//    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pkgName]];
//}
//
//// js端 app.showMessage(msg)
//- (void)showMessage:(NSString*)message
//{
//    [CommTool showStaus:message withType:TSMessageTypeInfo];
//}

@end
