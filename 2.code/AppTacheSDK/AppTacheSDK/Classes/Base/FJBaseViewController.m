//
//  FJBaseViewController.m
//  AppTache
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "FJBaseViewController.h"

@interface FJBaseViewController ()

@end

@implementation FJBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FJGlobalBG;
}

- (void)dealloc
{
    DLog(@"---dealloc---");
}

@end
