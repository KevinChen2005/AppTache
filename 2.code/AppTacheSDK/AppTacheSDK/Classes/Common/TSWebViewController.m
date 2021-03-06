//
//  TSWebViewController.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSWebViewController.h"

@interface TSWebViewController ()

@end

@implementation TSWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 1. 关闭按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    [button.titleLabel setFont:FJNavbarItemFont];
    // 颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setImage:kIconFontImageBackWhite forState:UIControlStateNormal];
    [button setImage:kIconFontImageBackWhite forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)back
{
    if ([[NSThread currentThread] isMainThread]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
