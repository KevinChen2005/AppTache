//
//  TSRegisterView.m
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSRegisterView.h"

@interface TSRegisterView()

@property (nonatomic, strong)UIButton* agreeProtocolBtn;
@property (nonatomic, strong)UITextField* phoneLabel;
@property (nonatomic, strong)UITextField* verifyCodeLabel;

@end

@implementation TSRegisterView

- (instancetype)init
{
    if (self = [super init]) {
        // 1. BuildUI
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    // 1. title
    UILabel* loginTitle = [UILabel new];
    [loginTitle setFont:[UIFont systemFontOfSize:17]];
    [loginTitle setTextAlignment:NSTextAlignmentCenter];
    [loginTitle setText:FJTextSDKRegisterName];
    [loginTitle setTextColor:FJColorLoginRed];
    [self.contentView addSubview:loginTitle];
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@40);
    }];
    
    // 2. phoneLabel
    UITextField* phoneLabel = [UITextField new];
    phoneLabel.placeholder = @"请输入手机号";
    phoneLabel.borderStyle = UITextBorderStyleRoundedRect;
    phoneLabel.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
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
        make.top.mas_equalTo(loginTitle.mas_bottom);
        make.right.mas_equalTo(self.contentView).offset(-kMargin).priorityHigh();
        make.width.mas_equalTo(@85).priorityHigh();
        make.height.mas_equalTo(@40);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginTitle.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(verifyCodeBtn.mas_left).offset(10);
        make.height.mas_equalTo(@40);
    }];
    
    // 3. 验证码
    UITextField* verifyCodeLabel = [UITextField new];
    verifyCodeLabel.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeLabel.placeholder = @"请输入验证码";
    verifyCodeLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.contentView addSubview:verifyCodeLabel];
    self.verifyCodeLabel = verifyCodeLabel;
    
    [verifyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(self.contentView).offset(-kMargin).priorityHigh();
        make.height.mas_equalTo(@40);
    }];
    
    // 4. agreeProtocolBtn
    UIButton* agreeProtocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeProtocolBtn setImage:[UIImage imageNamed:@"AppTacheSDK.bundle/images/tu_ic_weixuanzhong"] forState:UIControlStateNormal];
    [agreeProtocolBtn setImage:[UIImage imageNamed:@"AppTacheSDK.bundle/images/tu_ic_xuanzhong"] forState:UIControlStateSelected];
    agreeProtocolBtn.selected = YES;
    [self.contentView addSubview:agreeProtocolBtn];
    self.agreeProtocolBtn = agreeProtocolBtn;
    
    [agreeProtocolBtn addTarget:self action:@selector(onClickAgreeProtocol:) forControlEvents:UIControlEventTouchUpInside];
    
    [agreeProtocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verifyCodeLabel.mas_bottom).offset(6);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.height.mas_equalTo(@28);
        make.width.mas_equalTo(@28);
    }];
    
    // 5. notice
    UILabel* notice = [[UILabel alloc] init];
    notice.font = [UIFont systemFontOfSize:15];
    notice.textColor = FJColorLightGray;
    notice.text = @"我已阅读并同意";
    notice.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:notice];
    
    [notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verifyCodeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(agreeProtocolBtn.mas_right).offset(5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@110);
    }];
    
    // 6. protocolBtn
    UIButton* protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [protocolBtn setTitleColor:FJColorLoginRed forState:UIControlStateNormal];
    [protocolBtn setTitle:@"《服务协议》" forState:UIControlStateNormal];
    [self.contentView addSubview:protocolBtn];
    
    [protocolBtn addTarget:self action:@selector(onClickShowProtocol:) forControlEvents:UIControlEventTouchUpInside];
    
    [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verifyCodeLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(notice.mas_right).offset(-5);
        make.height.mas_equalTo(@20);
        make.width.mas_equalTo(@90);
    }];
    
    // 6.1 line under protocolBtn
    UIView* line = [UIView new];
    line.backgroundColor = FJColorLoginRed;
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolBtn.mas_bottom).offset(-2);
        make.left.mas_equalTo(protocolBtn).offset(5);
        make.right.mas_equalTo(protocolBtn).offset(-5);
        make.height.mas_equalTo(@1);
    }];
    
    // 7. registerBtn
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:FJColorLoginOrange];
    registerBtn.layer.cornerRadius = 3;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:registerBtn];
    
    [registerBtn addTarget:self action:@selector(onClickRegister:) forControlEvents:UIControlEventTouchUpInside];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(protocolBtn.mas_bottom).offset(12);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(self.contentView).offset(-kMargin).priorityHigh();
        make.height.mas_equalTo(@40);
    }];
    
    // 8. backLoginBtn
    UIButton* backLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backLoginBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
    [backLoginBtn setTitle:@"返回登录\U0000e021" forState:UIControlStateNormal];
    [backLoginBtn setTitleColor:FJBlackContent forState:UIControlStateNormal];
    backLoginBtn.titleLabel.font = [UIFont fontWithName:@"iconfont" size:16];//设置label的字体
    [self.contentView addSubview:backLoginBtn];
    
    [backLoginBtn addTarget:self action:@selector(onClickBackLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [backLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.height.mas_equalTo(@25);
        make.width.mas_equalTo(@85);
    }];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (hidden) {
        self.phoneLabel.text = @"";
        self.verifyCodeLabel.text = @"";
    }
}

- (void)onClickAgreeProtocol:(UIButton*)sender
{
    [self endEditing:YES];
    
    sender.selected = !sender.selected;
}

- (void)onClickRegister:(UIButton*)sender
{
    [self endEditing:YES];
    
    if (_agreeProtocolBtn.selected == NO) {
        [FJPopView showAlertWithTitle:@"提示" message:@"请先同意服务协议"];
        return;
    }
    
    NSString* phone = self.phoneLabel.text;
    if ([phone isNullString] || ![phone isPhoneNumber]) {
        [CommTool showStaus:@"请输入正确的手机号" withType:TSMessageTypeWarnning];
        return;
    }
    
    NSString* code = self.verifyCodeLabel.text;
    if ([code isNullString]) {
        [CommTool showStaus:@"请输入验证码" withType:TSMessageTypeWarnning];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(registerView:onClickRegister:phone:code:)]) {
        [_delegate registerView:self onClickRegister:sender phone:phone code:code];
    }
}

- (void)onClickShowProtocol:(UIButton*)sender
{
    [self endEditing:YES];
    
    if ([_delegate respondsToSelector:@selector(registerView:onClickShowProtocol:)]) {
        [_delegate registerView:self onClickShowProtocol:sender];
    }
}

- (void)onClickBackLoginBtn:(UIButton*)sender
{
    [self endEditing:YES];
    
    if ([_delegate respondsToSelector:@selector(registerView:onClickBackLogin:)]) {
        [_delegate registerView:self onClickBackLogin:sender];
    }
}

- (void)onClickVerifyCode:(FJVerifyCodeButton*)sender
{
    [self endEditing:YES];
    
    NSString* phone = self.phoneLabel.text;
    
    if ([phone isNullString] || ![phone isPhoneNumber]) {
        [CommTool showStaus:@"请输入正确的手机号" withType:TSMessageTypeWarnning];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(registerView:onClickVerifyCode:phone:)]) {
        [_delegate registerView:self onClickVerifyCode:sender phone:phone];
    }
    
    [sender startCountdown];
}

@end
