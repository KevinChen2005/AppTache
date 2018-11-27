//
//  TSNavigationController.m
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSNavigationController.h"

@interface TSNavigationController ()

@end

@implementation TSNavigationController

/**
 *  第一次使用调用一次
 */
+ (void)initialize
{
    // 设置导航图片
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    [bar setBarTintColor:FJBlackTitle]; //导航栏背景
    
    [bar setTitleTextAttributes:@{
                                  NSForegroundColorAttributeName : FJColorWhite,
                                  NSFontAttributeName : [UIFont systemFontOfSize:18.0]
                                  }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 拦截push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
        [button.titleLabel setFont:FJNavbarItemFont];
        // 颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setImage:kIconFontImageBackWhite forState:UIControlStateNormal];
        [button setImage:kIconFontImageBackWhite forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
