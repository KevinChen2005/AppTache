//
//  TSRegisterView.h
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBaseLoginView.h"

@protocol TSRegisterViewDelegate;

@interface TSRegisterView : TSBaseLoginView

@property (nonatomic, weak)id<TSRegisterViewDelegate> delegate;

@end

@protocol TSRegisterViewDelegate <NSObject>

@optional

- (void)registerView:(TSRegisterView*)loginView onClickRegister:(UIButton*)sender phone:(NSString*)phone code:(NSString*)code;

- (void)registerView:(TSRegisterView*)loginView onClickShowProtocol:(UIButton*)sender;

- (void)registerView:(TSRegisterView*)loginView onClickBackLogin:(UIButton*)sender;

- (void)registerView:(TSRegisterView*)loginView onClickVerifyCode:(UIButton*)sender phone:(NSString*)phone;

@end
