//
//  TSBindAccountCodeViewController.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBindAccountCodeViewController.h"

@interface TSBindAccountCodeViewController ()

@property (nonatomic, strong)UITextField* verifyCodeLabel;

@end

@implementation TSBindAccountCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 2. password
    UITextField* verifyCodeLabel = [UITextField new];
    verifyCodeLabel.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    verifyCodeLabel.placeholder = @"请输入验证码";
    [self.contentView addSubview:verifyCodeLabel];
    self.verifyCodeLabel = verifyCodeLabel;
    
    // 2.1 verifyCodeBtn
    FJVerifyCodeButton* verifyCodeBtn = [FJVerifyCodeButton buttonWithType:UIButtonTypeCustom];
    [verifyCodeBtn setTitleColor:FJColorWhite forState:UIControlStateNormal];
    [verifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyCodeBtn setBackgroundColor:FJColorLoginOrange];
    verifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    verifyCodeBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:verifyCodeBtn];
    
    [verifyCodeBtn addTarget:self action:@selector(onClickVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [verifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-kMargin);
        make.width.mas_equalTo(@85);
        make.height.mas_equalTo(@40);
    }];
    
    [verifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(verifyCodeBtn.mas_left).offset(10);
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
        make.top.mas_equalTo(verifyCodeLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}

// 获取验证码
- (void)onClickVerifyCode:(FJVerifyCodeButton*)sender
{
    [sender startCountdown];
    
    [[SdkManager shareInstance] sdkGetVerfyCodeWithPhone:self.phone];
}

// 确认
- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* code = self.verifyCodeLabel.text;
    if (code == nil || [code isEqualToString:@""]) {
        [CommTool showStaus:@"输入验证码" withType:TSMessageTypeWarnning];
        return;
    }
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* password = [TSLoginModel shareInstance].password;
    NSString* token = [TSLoginModel shareInstance].token;
    
    if (self.type == TSBindAccountTypeBind) {
        [[SdkManager shareInstance] sdkBindAccount:account password:password token:token phone:self.phone verificationCode:code success:^{
            
            [self backToRootViewController];
        }];
    } else {
        [[SdkManager shareInstance] sdkUnBindAccount:account password:password token:token phone:self.phone verificationCode:code success:^{
            
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
