//
//  TSLoginViewController.m
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSLoginViewController.h"
#import "TSLoginView.h"
#import "TSRegisterView.h"
#import "TSForgetPwdViewController.h"

@interface TSLoginViewController () <TSLoginViewDelegate, TSRegisterViewDelegate>

@property (nonatomic, strong)TSLoginView* loginView;
@property (nonatomic, strong)TSRegisterView* registerView;

@end

@implementation TSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    
    // 1.添加loginView
    TSLoginView* loginView = [TSLoginView new];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    self.loginView = loginView;
    
    // 2.添加registerView
    TSRegisterView* registerView = [TSRegisterView new];
    registerView.delegate = self;
    [self.view addSubview:registerView];
    self.registerView = registerView;
    self.registerView.hidden = YES;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self updateConstraint];
}

- (void)updateConstraint
{
    // 1.设置loginView约束
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        
        CGFloat minWidth = MIN(kScreenWidth, kScreenHeight);
        if (kScreenWidth > kScreenHeight) { // 横屏
            if (isIpad) {
                make.width.mas_equalTo(@(minWidth * 0.55));
                make.height.mas_equalTo(@(minWidth * 0.5));
            } else {
                make.width.mas_equalTo(@(minWidth * 1.1));
                make.height.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 0.95)));
            }
        } else { // 竖屏
            if (isIpad) {
                make.width.mas_equalTo(@(minWidth * 0.55));
                make.height.mas_equalTo(@(minWidth * 0.5));
            } else {
                make.width.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 1.0)));
                make.height.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 0.95)));
            }
        }
    }];
    
    // 2.设置registerView约束
    [self.registerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);

        CGFloat minWidth = MIN(kScreenWidth, kScreenHeight);
        if (kScreenWidth > kScreenHeight) { // 横屏
            if (isIpad) {
                make.width.mas_equalTo(@(minWidth * 0.55));
                make.height.mas_equalTo(@(minWidth * 0.5));
            } else {
                make.width.mas_equalTo(@(minWidth * 1.1));
                make.height.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 0.95)));
            }
        } else { // 竖屏
            if (isIpad) {
                make.width.mas_equalTo(@(minWidth * 0.55));
                make.height.mas_equalTo(@(minWidth * 0.5));
            } else {
                make.width.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 1.0)));
                make.height.mas_equalTo(@(minWidth * (minWidth>320 ? 0.9 : 0.95)));
            }
        }
    }];
}

// 监控触摸控制器视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    UITouch *touch = [touches anyObject];
    UIView* view = [touch view];
    
    // 关闭选账号列表
    [self.loginView closeUserListView];
    
    // 如果点击的不是父控件就返回
    if(![view isEqual:self.view]) {
        return;
    }
    
    //点击蒙版退出登录框
//    [self dismissViewControllerAnimated:YES completion:nil];
}

// 退出登录控制器
- (void)onCloseLoginView
{
    if ([NSThread currentThread].isMainThread) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 登录页面回调TSLoginViewDelegate

//点击登录
- (void)loginView:(TSLoginView *)loginView onClickLogin:(UIButton *)sender username:(NSString*)username password:(NSString*)password
{
    DLog();
    
    [self.view endEditing:YES];
    
    WEAKSELF
    [[SdkManager shareInstance] sdkLogin:username password:password success:^{
        STRONGSELF
        [strongSelf onCloseLoginView];
    }];
}

//点击游客登录
- (void)loginView:(TSLoginView *)loginView onClickTouristLogin:(UIButton *)sender
{
    DLog();
    
    [self.view endEditing:YES];
    
    WEAKSELF
    [[SdkManager shareInstance] sdkTouristLoginSuccess:^{
        STRONGSELF
        [strongSelf onCloseLoginView];
    }];
}

//点击手机注册
- (void)loginView:(TSLoginView *)loginView onClickPhoneRegister:(UIButton *)sender
{
    DLog();
    
    [self.view endEditing:YES];
    
    self.registerView.hidden = NO;
}

//点击忘记密码
- (void)loginView:(TSLoginView *)loginView onClickForgetPassword:(UIButton *)sender
{
    DLog();
    
    [self.view endEditing:YES];
    
    TSForgetPwdViewController* forgetVC = [TSForgetPwdViewController new];
    forgetVC.titles = @[@"确认账号", @"设新密码", @"安全验证"];
    forgetVC.title = @"找回密码";
    
    TSNavigationController* navVC = [[TSNavigationController alloc] initWithRootViewController:forgetVC];
    [self presentViewController:navVC animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findPwd) name:@"kNotificationFindPasswordSuccess" object:nil];
}

- (void)findPwd
{
    NSString* account = [TSLoginModel shareInstance].account;
    NSString* pwd = [TSLoginModel shareInstance].password;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.loginView setAccount:account password:pwd];
    });
}

#pragma mark - 注册页面回调TSRegisterViewDelegate

//点击注册按钮
- (void)registerView:(TSRegisterView*)loginView onClickRegister:(UIButton*)sender phone:(NSString*)phone code:(NSString*)code
{
    DLog();
    
    WEAKSELF
    [[SdkManager shareInstance] sdkRegisterWithPhone:phone verifyCode:code success:^{
        STRONGSELF
        [strongSelf onCloseLoginView];
    }];
}

//点击用户协议
- (void)registerView:(TSRegisterView*)loginView onClickShowProtocol:(UIButton*)sender
{
    DLog();
    
    [[SdkManager shareInstance] sdkShowUserProtocol:self];
}

//点击返回登录按钮
- (void)registerView:(TSRegisterView*)loginView onClickBackLogin:(UIButton*)sender
{
    DLog();
    
    self.registerView.hidden = YES;
}

//点击获取验证码按钮
- (void)registerView:(TSRegisterView*)loginView onClickVerifyCode:(UIButton*)sender phone:(NSString*)phone
{
    DLog();
    
    [[SdkManager shareInstance] sdkGetVerfyCodeWithPhone:phone];
}

@end

