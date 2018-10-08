//
//  TSBindAccountPhoneViewController.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBindAccountPhoneViewController.h"
#import "TSBindAccountCodeViewController.h"

@interface TSBindAccountPhoneViewController ()

@property (nonatomic, strong)UITextField* phoneLabel;

@end

@implementation TSBindAccountPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUIs];
}

- (void)buildUIs
{    
    // 2. phoneLabel
    UITextField* phoneLabel = [UITextField new];
    phoneLabel.borderStyle = UITextBorderStyleRoundedRect;
    phoneLabel.placeholder = @"请输入手机号";
    phoneLabel.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(phoneLabel.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
}

- (void)onClickConfirmBtn:(UIButton*)sender
{
    NSString* phone = self.phoneLabel.text;
    if (phone == nil || [phone isEqualToString:@""]) {
        [CommTool showStaus:@"请输入手机号" withType:TSMessageTypeWarnning];
        return;
    }
    
    if (![phone isPhoneNumber]) {
        [CommTool showStaus:@"手机号格式不正确" withType:TSMessageTypeWarnning];
        return;
    }
    
    if (self.type == TSBindAccountTypeUnBind && ![phone isEqualToString:[TSLoginModel shareInstance].phone]) {
        [CommTool showStaus:@"手机号错误" withType:TSMessageTypeError];
        return;
    }
    
    TSBindAccountCodeViewController* codeVC = [TSBindAccountCodeViewController new];
    codeVC.title = self.title;
    codeVC.titles = self.titles;
    codeVC.phone = phone;
    codeVC.type = self.type;
    [self.navigationController pushViewController:codeVC animated:YES];
}

@end
