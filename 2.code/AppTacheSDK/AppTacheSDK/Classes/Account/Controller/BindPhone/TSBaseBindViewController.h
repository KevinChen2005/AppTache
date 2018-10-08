//
//  TSBaseBindViewController.h
//  AppTache
//
//  Created by admin on 2018/9/20.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBaseAccountViewController.h"

typedef NS_ENUM(NSInteger, TSBindAccountType)
{
    TSBindAccountTypeBind = 0, //绑定账号
    TSBindAccountTypeUnBind,   //解绑账号
};

@interface TSBaseBindViewController : TSBaseAccountViewController

@property (nonatomic, assign)TSBindAccountType type;

@end
