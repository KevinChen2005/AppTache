//
//  TSModifyPasswordViewController.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSModifyPasswordViewController.h"

#define kPlaceholderOld @"请输入旧密码"
#define kPlaceholderNew @"请输入新密码"

@interface TSModifyPasswordViewController ()

@property (nonatomic, strong)UITextField* password;
@property (nonatomic, copy)NSString* oldPwd;

@end

@implementation TSModifyPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改密码";
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 1.title
    UILabel* label = [UILabel new];
    label.textColor = FJBlackTitle;
    label.backgroundColor = FJColorWhite;
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = FJTextSDKInitPwdTips;
    [self.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(@30);
    }];
    
    // 2. password
    UITextField* password = [UITextField new];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.placeholder = kPlaceholderOld;
    password.keyboardType = UIKeyboardTypeAlphabet;
    [self.contentView addSubview:password];
    self.password = password;
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(30);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(self.contentView).offset(-kMargin);
        make.height.mas_equalTo(@40);
    }];
    
    // 3.confirmBtn
    UIButton* confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:FJColorWhite forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:FJColorLoginOrange];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:confirmBtn];
    
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(password.mas_bottom).offset(30);
        make.centerX.mas_equalTo(label.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}

- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* pwd = self.password.text;
    
    if ([self.password.placeholder isEqualToString:kPlaceholderOld]) {
        if (pwd == nil || [pwd isEqualToString:@""]) {
            [CommTool showStaus:@"请输入旧密码" withType:TSMessageTypeInfo];
            return;
        }
        
        if (![pwd isEqualToString:[TSLoginModel shareInstance].password]) {
            [CommTool showStaus:@"旧密码错误" withType:TSMessageTypeError];
            return;
        }
        
        self.password.placeholder = kPlaceholderNew;
        self.password.text = @"";
        self.oldPwd = pwd;
        
    } else {
        if (pwd == nil || [pwd isEqualToString:@""]) {
            [CommTool showStaus:@"请输入新密码" withType:TSMessageTypeInfo];
            return;
        }
        
        NSString* account = [TSLoginModel shareInstance].account;
        NSString* token = [TSLoginModel shareInstance].token;
        
        NSString* newPwd = pwd;
        
        [[SdkManager shareInstance] sdkModifyPasswordWithAccount:account oldPwd:self.oldPwd password:newPwd token:token verificationCode:@"" success:^{
            [self backToRootViewController];
        }];
    }
}

- (void)backToRootViewController
{
    [[SdkManager shareInstance] sdkShowFloatView];
    
    if ([NSThread currentThread].isMainThread) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
