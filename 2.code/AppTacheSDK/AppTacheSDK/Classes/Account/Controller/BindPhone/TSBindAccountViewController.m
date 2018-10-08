//
//  TSBindAccountViewController.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBindAccountViewController.h"
#import "TSBindAccountPhoneViewController.h"

@interface TSBindAccountViewController ()

@property (nonatomic, strong)UITextField* password;

@end

@implementation TSBindAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 1.title
    UILabel* label = [UILabel new];
    label.textColor = FJBlackTitle;
    label.backgroundColor = FJColorWhite;
    label.layer.cornerRadius = 5;
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
    password.keyboardType = UIKeyboardTypeAlphabet;
    password.placeholder = @"请输入密码";
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
    
    // 4. infoLabel
    UILabel* infoLabel = [UILabel new];
    infoLabel.textColor = FJColorWhite;
    infoLabel.backgroundColor = FJColorLoginOrange;
    infoLabel.layer.cornerRadius = 5;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    // 5. 改变显示状态
    if (self.type == TSBindAccountTypeBind) {
        infoLabel.text    = [NSString stringWithFormat:@"已绑定手机%@",[TSLoginModel shareInstance].phone];
        infoLabel.hidden  = ![TSLoginModel shareInstance].isBindPhone;
        label.hidden      =  [TSLoginModel shareInstance].isBindPhone;
        password.hidden   =  [TSLoginModel shareInstance].isBindPhone;
        confirmBtn.hidden =  [TSLoginModel shareInstance].isBindPhone;
    } else {
        infoLabel.text    = @"未绑定手机号";
        infoLabel.hidden  =  [TSLoginModel shareInstance].isBindPhone;
        label.hidden      = ![TSLoginModel shareInstance].isBindPhone;
        password.hidden   = ![TSLoginModel shareInstance].isBindPhone;
        confirmBtn.hidden = ![TSLoginModel shareInstance].isBindPhone;
    }
    
}

- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* pwd = self.password.text;
    if (pwd == nil || [pwd isEqualToString:@""]) {
        [CommTool showStaus:@"请输入密码" withType:TSMessageTypeWarnning];
        return;
    }
    
    if (![pwd isEqualToString:[TSLoginModel shareInstance].password]) {
        [CommTool showStaus:@"密码不正确" withType:TSMessageTypeError];
        return;
    }
    
    TSBindAccountPhoneViewController* phoneVC = [TSBindAccountPhoneViewController new];
    phoneVC.title = self.title;
    phoneVC.titles = self.titles;
    phoneVC.type = self.type;
    [self.navigationController pushViewController:phoneVC animated:YES];
}

@end
