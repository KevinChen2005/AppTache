//
//  FJBaseWebViewController.h
//  AppTache
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "FJBaseViewController.h"

@interface FJBaseWebViewController : FJBaseViewController

/**
 URL地址，如果url不为空，优先加载url
 */
@property(nonatomic, copy)NSString *urlString;

/**
 html，如果url为空，加载html数据
 */
@property(nonatomic, copy)NSString *htmlString;

- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
