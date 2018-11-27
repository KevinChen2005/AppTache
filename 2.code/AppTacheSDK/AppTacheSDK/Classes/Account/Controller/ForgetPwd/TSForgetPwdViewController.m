//
//  TSForgetPwdViewController.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSForgetPwdViewController.h"
#import "TSForgetPwdPhoneViewController.h"
#import "WKVerCodeImageView.h"

@interface TSForgetPwdViewController ()

@property (nonatomic, strong) WKVerCodeImageView *codeImageView;

@property (nonatomic, strong) UITextField* userName;
@property (nonatomic, strong) UITextField* verifyCode;

@property (nonatomic, strong) UIButton* confirmBtn;

@property (nonatomic, strong) UILabel* infoLabel;

@end

@implementation TSForgetPwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取账号信息，如账号对应的手机绑定信息
//    [[SdkManager shareInstance] sdkGetAccountInfo];
    
    [self buildUIs];
}

- (void)buildUIs
{
    // 1. 关闭按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    [button.titleLabel setFont:FJNavbarItemFont];
    // 颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setImage:kIconFontImageBackWhite forState:UIControlStateNormal];
    [button setImage:kIconFontImageBackWhite forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 2. userName
    UITextField* userName = [UITextField new];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.placeholder = @"请输入账号";
    userName.keyboardType = UIKeyboardTypeAlphabet;
    [self.contentView addSubview:userName];
    self.userName = userName;
    
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(self.contentView).offset(-kMargin);
        make.height.mas_equalTo(@40);
    }];
    
    // 2. verifyCode
    UITextField* verifyCode = [UITextField new];
    verifyCode.borderStyle = UITextBorderStyleRoundedRect;
    verifyCode.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    verifyCode.placeholder = @"请输入验证码";
    [self.contentView addSubview:verifyCode];
    self.verifyCode = verifyCode;
    
    // 2.1 verifyCodeBtn
    _codeImageView = [[WKVerCodeImageView alloc] initWithFrame:CGRectMake(160, 60, 80, 35)];
    //是否需要斜体
    _codeImageView.isRotation = NO;
    _codeImageView.backColor = FJColorLoginOrange;
    _codeImageView.layer.cornerRadius = 5;
    _codeImageView.clipsToBounds = YES;
    [self onClickVerifyCode:nil];
    
    //点击刷新
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickVerifyCode:)];
    [_codeImageView addGestureRecognizer:tap];
    [self.view addSubview: _codeImageView];
    
    [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userName.mas_bottom).offset(30);
        make.right.mas_equalTo(self.contentView).offset(-kMargin);
        make.width.mas_equalTo(@85);
        make.height.mas_equalTo(@40);
    }];

    [verifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(userName.mas_bottom).offset(30);
        make.left.mas_equalTo(self.contentView).offset(kMargin);
        make.right.mas_equalTo(self.codeImageView.mas_left).offset(10);
        make.height.mas_equalTo(@40);
    }];
    
    
    // 4.confirmBtn
    UIButton* confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitleColor:FJColorWhite forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:FJColorLoginOrange];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmBtn.layer.cornerRadius = 5;
    [self.contentView addSubview:confirmBtn];
    self.confirmBtn = confirmBtn;
    
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(verifyCode.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(0.6);
    }];
    
    // 5. infoLabel
    UILabel* infoLabel = [UILabel new];
    infoLabel.textColor = FJColorWhite;
    infoLabel.backgroundColor = FJColorLoginOrange;
    infoLabel.layer.cornerRadius = 5;
    infoLabel.font = [UIFont systemFontOfSize:16];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(@40);
    }];
    
    [self chanageState:YES];
    
}

// 刷新图形验证码
- (void)onClickVerifyCode:(id)sender
{
    [self.view endEditing:YES];
    
    [HttpTool getVerificationCodeWithPhone:@"" type:@"1" success:^(id retObj) {
        DLog(@"retObj = %@", retObj);
        NSString* code = [retObj objectForKey:@"verificationCode"];
        [self.codeImageView setVerCode:code];
    } failure:^(NSError *error) {
        DLog(@"error = %@", error);
        [self.codeImageView setVerCode:@""];
    }];
}

// 确认
- (void)onClickConfirmBtn:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    NSString* account = self.userName.text;
    NSString* code = self.verifyCode.text;
    NSString* imageCode = self.codeImageView.imageCodeStr;
    
    if (account==nil || [account isEqualToString:@""]) {
        [CommTool showStaus:@"请输入要找回密码的账号" withType:TSMessageTypeInfo];
        return;
    }
    
    if (code==nil || [code isEqualToString:@""]) {
        [CommTool showStaus:@"请输入验证码" withType:TSMessageTypeInfo];
        return;
    }
    
    if (![code isEqualToString:imageCode]) {
        [CommTool showStaus:@"输入验证码错误" withType:TSMessageTypeError];
        return;
    }
    
    [[SdkManager shareInstance] sdkGetAccountInfoWithAccount:account password:@"" token:@"" success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushVC];
        });
    }];
}

- (void)pushVC
{
    if ([TSLoginModel shareInstance].isBindPhone) {
        TSForgetPwdPhoneViewController* phoneVC = [TSForgetPwdPhoneViewController new];
        phoneVC.title = self.title;
        phoneVC.titles = self.titles;
        [self.navigationController pushViewController:phoneVC animated:YES];
    } else {
        [self chanageState:NO];
    }    
}

- (void)chanageState:(BOOL)bind
{
    // 改变显示状态
    self.infoLabel.text       =   bind ? @"" : @"该账号未绑定手机号";
    self.infoLabel.hidden     =   bind;
    self.userName.hidden      =  !bind;
    self.verifyCode.hidden    =  !bind;
    self.codeImageView.hidden =  !bind;
    self.confirmBtn.hidden    =  !bind;
}

- (void)back
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

