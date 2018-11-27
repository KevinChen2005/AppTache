//
//  TSPayViewController.m
//  AppTache
//
//  Created by admin on 2018/9/21.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSPayViewController.h"
#import "HYBJsObjCModel.h"

#define APP_Scheme_host @"www.xdragonnet.com" //用于第三方支付完成后跳转，应用中需要设置该scheme
#define APP_Scheme      @"www.xdragonnet.com://"

@interface TSPayViewController ()<HYBJsObjCModelDelegate>
{
    BOOL _bClickDoTrade; //是否点了支付页面的确认支付按钮（如果没点返回后就不查询支付结果）
}

@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *redirectUrl; //记录回调地址

@end

@implementation TSPayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bClickDoTrade = NO;
    
    self.jsContext = [[JSContext alloc] init];
    self.redirectUrl = @"";
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
}

- (void)back
{
    [super back];
    
    [[SdkManager shareInstance] sdkShowFloatView];
    
    if (_orderId == nil || [_orderId isEqualToString:@""]) {
        return;
    }
    
    // 只有调起了三方支付后才进行结果查询
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

    // 微信回调处理一：替换回调地址为scheme，同时记录下来正式的回调地址了，以便支付完成回调
    NSString *urlsss = request.URL.absoluteString;
    NSString *wxPre = @"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb";
    NSString *redirectUrl = [NSString stringWithFormat:@"redirect_url=%@", APP_Scheme];
    if ([urlsss hasPrefix:wxPre] && ![urlsss containsString:redirectUrl]) {
        NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        
        NSString *newURLStr = nil;
        //TODO: 对newURLStr追加或修改参数redirect_url=URLEncode(A.company.com://)
        NSRange range = [urlsss rangeOfString:@"redirect_url="];
        if (range.location<100000) {
            newURLStr = [urlsss substringToIndex:range.location];
            
            //记录下来正式的回调地址了
            self.redirectUrl = [urlsss substringFromIndex:range.location+range.length];
        } else {
            newURLStr = urlsss;
        }
        
        // 用新的请求地址请求
        newURLStr = [newURLStr stringByAppendingString:redirectUrl];
        newRequest.URL = [NSURL URLWithString:newURLStr];
        [webView loadRequest:newRequest];
        
        return NO;
    }
    
    // 微信回调处理二：回调后如果是scheme，换成回调地址，便于应用内浏览器加载支付回调页面
    if ([urlsss isEqualToString:APP_Scheme]) {
        NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        
        NSString *newURLStr = [self.redirectUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (newURLStr && ![newURLStr isEqualToString:@""]) {
            newRequest.URL = [NSURL URLWithString:newURLStr];
            [webView loadRequest:newRequest];
        }
        
        return NO;
    }
    
    
    // 调起三方支付
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
    
    // 开启一个新浏览器打开支付链接
    if ([Utils startWith:strA forString:urlString] ||
        [Utils startWith:strW forString:urlString]) {
        
        //utf8解码
        NSString* urlStringNormal = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"url=%@", urlStringNormal);
        
        _bClickDoTrade = YES;
        
        //如果是支付宝支付，替换scheme，以便支付成功能够跳转回app
        NSString* al_scheme = @"\"fromAppUrlScheme\":\"alipays\"";
        NSString* al_scheme_new = [NSString stringWithFormat:@"\"fromAppUrlScheme\":\"%@\"", APP_Scheme_host];
        if ([urlStringNormal containsString:al_scheme]) {
            urlStringNormal = [urlStringNormal stringByReplacingOccurrencesOfString:al_scheme withString:al_scheme_new];
        }
        
        //utf8编码
        urlString = [urlStringNormal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //新webView打开
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

            [self.webView loadRequest:request];
        });
        
        return NO;
    }
    
    //微信请求需要设置Referer
    NSString* refererFlag = APP_Scheme_host;
    NSString* refererStr  = APP_Scheme;
    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [[headers objectForKey:@"Referer"]  containsString:refererFlag];
    
    if (!hasReferer && [urlString containsString:refererFlag] && ![urlString containsString:@"alipay"]) { //如果判断如果不包含支付宝的字样则认为是微信链接
        // relaunch with a modified request
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
                //                [request setHTTPMethod:@"GET"];
                [request setValue:refererStr forHTTPHeaderField: @"Referer"];
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
