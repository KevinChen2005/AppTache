//
//  TSLoginView.h
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBaseLoginView.h"

@protocol TSLoginViewDelegate;

@interface TSLoginView : TSBaseLoginView

@property (nonatomic, weak)id<TSLoginViewDelegate> delegate;

/**
 关闭账号列表
 */
- (void)closeUserListView;

/**
 设置登录框账号、密码View的值
 */
- (void)setAccount:(NSString*)account password:(NSString*)password;

@end


@protocol TSLoginViewDelegate <NSObject>

@optional

/**
 点击手机注册回调
 */
- (void)loginView:(TSLoginView*)loginView onClickPhoneRegister:(UIButton*)sender;

/**
 点击忘记密码回调
 */
- (void)loginView:(TSLoginView*)loginView onClickForgetPassword:(UIButton*)sender;

/**
 点击游客登录回调
 */
- (void)loginView:(TSLoginView*)loginView onClickTouristLogin:(UIButton*)sender;

/**
 点击登录回调
 */
- (void)loginView:(TSLoginView *)loginView onClickLogin:(UIButton *)sender username:(NSString*)username password:(NSString*)password;

@end
