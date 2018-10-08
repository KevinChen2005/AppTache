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

- (void)closeUserListView;
- (void)setAccount:(NSString*)account password:(NSString*)password;

@end

@protocol TSLoginViewDelegate <NSObject>

@optional

- (void)loginView:(TSLoginView*)loginView onClickPhoneRegister:(UIButton*)sender;

- (void)loginView:(TSLoginView*)loginView onClickForgetPassword:(UIButton*)sender;

- (void)loginView:(TSLoginView*)loginView onClickTouristLogin:(UIButton*)sender;

- (void)loginView:(TSLoginView *)loginView onClickLogin:(UIButton *)sender username:(NSString*)username password:(NSString*)password;

@end
