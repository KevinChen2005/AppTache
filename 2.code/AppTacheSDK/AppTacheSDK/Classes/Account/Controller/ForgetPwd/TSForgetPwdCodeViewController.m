//
//  TSForgetPwdCodeViewController.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSForgetPwdCodeViewController.h"

@interface TSForgetPwdCodeViewController ()

@property (nonatomic, strong)UITextField* verifyCode;

@end

@implementation TSForgetPwdCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 2. verifyCode
    UITextField* verifyCode = [UITextField new];
    verifyCode.borderStyle = UITextBorderStyleRoundedRect;
    verifyCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    verifyCode.placeholder = @"请输入验证码";
    [self.contentView addSubview:verifyCode];
    self.verifyCode = verifyCode;
    
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
        make.top.mas_equalTo(self.contentView).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-kMargin);
        make.width.mas_equalTo(@85);
        make.height.mas_equalTo(@40);
    }];
    
    [verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(30);
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
        make.top.mas_equalTo(verifyCode.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}

- (void)onClickVerifyCode:(FJVerifyCodeButton*)sender
{
    [sender startCountdown];
    
    [[SdkManager shareInstance] sdkGetVerfyCodeWithPhone:[TSLoginModel shareInstance].phone];
}

- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* code = self.verifyCode.text;
    if (code == nil || [code isEqualToString:@""]) {
        [CommTool showStaus:@"输入验证码" withType:TSMessageTypeWarnning];
        return;
    }
    NSString* account = [TSLoginModel shareInstance].account;
    
    [[SdkManager shareInstance] sdkFindPasswordWithAccount:account oldPwd:@"" password:self.password token:@"" verificationCode:code success:^{
        [self backToRootViewController];
    }];
}

- (void)backToRootViewController
{
//    [[SdkManager shareInstance] sdkShowFloatView];
    
    if ([NSThread currentThread].isMainThread) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
