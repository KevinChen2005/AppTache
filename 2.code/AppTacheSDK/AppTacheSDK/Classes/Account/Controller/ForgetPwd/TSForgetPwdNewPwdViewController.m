//
//  TSForgetPwdNewPwdViewController.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSForgetPwdNewPwdViewController.h"
#import "TSForgetPwdCodeViewController.h"

@interface TSForgetPwdNewPwdViewController ()

@property (nonatomic, strong)UITextField* password;

@end

@implementation TSForgetPwdNewPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 2. password
    UITextField* password = [UITextField new];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.keyboardType = UIKeyboardTypeAlphabet;
    password.placeholder = @"请输入新密码";
    [self.contentView addSubview:password];
    self.password = password;
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
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
        make.centerX.mas_equalTo(password.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}

- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* newPwd = self.password.text;
    
    if (newPwd==nil || [newPwd isEqualToString:@""]) {
        [CommTool showStaus:@"请输入新密码" withType:TSMessageTypeInfo];
        return;
    }
    
    TSForgetPwdCodeViewController* codeVC = [TSForgetPwdCodeViewController new];
    codeVC.title = self.title;
    codeVC.titles = self.titles;
    codeVC.password = newPwd;
    [self.navigationController pushViewController:codeVC animated:YES];
}

@end
