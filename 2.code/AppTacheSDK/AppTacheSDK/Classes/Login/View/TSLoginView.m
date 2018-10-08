//
//  TSLoginView.m
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSLoginView.h"
#import "TSUserListView.h"
#import "FJMarqueeLabel.h"

@interface TSLoginView() <TSUserListViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic)UITextField *username;
@property (strong, nonatomic)UITextField *password;
@property (strong, nonatomic)UIButton *showUserListBtn;
@property (strong, nonatomic)TSUserListView* userListView;

@end

@implementation TSLoginView

- (instancetype)init
{
    if (self = [super init]) {
        // 1. title
        UILabel* loginTitle = [UILabel new];
        [loginTitle setFont:[UIFont systemFontOfSize:17]];
        [loginTitle setTextAlignment:NSTextAlignmentCenter];
        [loginTitle setText:FJTextSDKLoginName];
        [loginTitle setTextColor:FJBlackTitle];
        [self.contentView addSubview:loginTitle];
        
        [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@40);
        }];
        
        // 2. username
        UITextField* username = [UITextField new];
        username.placeholder = @"请输入账号";
        username.keyboardType = UIKeyboardTypeAlphabet;
        username.borderStyle = UITextBorderStyleRoundedRect;
        
        [self.contentView addSubview:username];
        self.username = username;
        
        [username mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginTitle.mas_bottom);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.right.mas_equalTo(self.contentView).offset(-kMargin).priorityHigh();
            make.height.mas_equalTo(@40);
        }];
        
        // 2.1 show/hide button
        UIButton* showUserListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [showUserListBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e022", 22, FJColorDarkGray)] forState:UIControlStateNormal];
        [showUserListBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e023", 22, FJColorDarkGray)] forState:UIControlStateSelected];
        showUserListBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
        [self.contentView addSubview:showUserListBtn];
        self.showUserListBtn = showUserListBtn;
        
        [showUserListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginTitle.mas_bottom).offset(1);
            make.right.mas_equalTo(username).offset(-1);
            make.bottom.mas_equalTo(username).offset(-1);
            make.width.mas_equalTo(@40);
        }];
        
        [showUserListBtn addTarget:self action:@selector(onClickShowUserList:) forControlEvents:UIControlEventTouchUpInside];
        
        // 2.2 line
        UIView* lineUsername = [UIView new];
        [lineUsername setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:lineUsername];
        
        [lineUsername mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginTitle.mas_bottom).offset(1);
            make.right.mas_equalTo(showUserListBtn.mas_left).offset(-1);
            make.bottom.mas_equalTo(username).offset(-1);
            make.width.mas_equalTo(@0.4);
        }];
        
        // 3. password
        UITextField* password = [UITextField new];
        password.borderStyle = UITextBorderStyleRoundedRect;
        password.placeholder = @"请输入密码";
        password.keyboardType = UIKeyboardTypeAlphabet;
        password.secureTextEntry = YES;
        password.delegate = self;
        [self.contentView addSubview:password];
        self.password = password;
        
        [password mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(username.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.right.mas_equalTo(self.contentView).offset(-kMargin).priorityHigh();
            make.height.mas_equalTo(@40);
        }];
        
        // 3.1 show/hide password button
        UIButton* showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [showPasswordBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e025", 22, FJColorDarkGray)] forState:UIControlStateNormal];
        [showPasswordBtn setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e024", 22, FJColorDarkGray)] forState:UIControlStateSelected];
        showPasswordBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:showPasswordBtn];
        
        [showPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(password).offset(1);
            make.right.mas_equalTo(password).offset(-1);
            make.bottom.mas_equalTo(password).offset(-1);
            make.width.mas_equalTo(@40);
        }];
        
        [showPasswordBtn addTarget:self action:@selector(onClickShowPassword:) forControlEvents:UIControlEventTouchUpInside];
        
        // 3.2 line
        UIView* linePassword = [UIView new];
        [linePassword setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:linePassword];
        
        [linePassword mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(password).offset(1);
            make.right.mas_equalTo(showPasswordBtn.mas_left).offset(-1);
            make.bottom.mas_equalTo(password).offset(-1);
            make.width.mas_equalTo(@0.4);
        }];
        
        // 4. phoneRegiterBtn
        UIButton* phoneRegiterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneRegiterBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [phoneRegiterBtn setTitleColor:FJColorLoginRed forState:UIControlStateNormal];
        [phoneRegiterBtn setTitle:@"手机注册" forState:UIControlStateNormal];
        [self.contentView addSubview:phoneRegiterBtn];
        
        [phoneRegiterBtn addTarget:self action:@selector(onClickPhoneRegister:) forControlEvents:UIControlEventTouchUpInside];
        
        [phoneRegiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(password.mas_bottom).offset(5);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@65);
        }];
        
        // 4.1 line under phoneRegiterBtn
        UIView* linePhone = [UIView new];
        linePhone.backgroundColor = FJColorLoginRed;
        [self.contentView addSubview:linePhone];
        
        [linePhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneRegiterBtn.mas_bottom).offset(-2);
            make.left.width.mas_equalTo(phoneRegiterBtn);
            make.height.mas_equalTo(@1);
        }];
        
        // 5. forgetPasswordBtn
        UIButton* forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [forgetPasswordBtn setTitleColor:FJColorLoginRed forState:UIControlStateNormal];
        [forgetPasswordBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [self.contentView addSubview:forgetPasswordBtn];
        
        [forgetPasswordBtn addTarget:self action:@selector(onClickForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        
        [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(password.mas_bottom).offset(5);
            make.right.mas_equalTo(self.contentView).offset(-kMargin);
            make.height.mas_equalTo(@20);
            make.width.mas_equalTo(@65);
        }];
        
        // 5.1 line under forgetPasswordBtn
        UIView* line = [UIView new];
        line.backgroundColor = FJColorLoginRed;
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(forgetPasswordBtn.mas_bottom).offset(-2);
            make.left.width.mas_equalTo(forgetPasswordBtn);
            make.height.mas_equalTo(@1);
        }];
        
        // 6. touristLoginBtn
        UIButton* touristLoginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [touristLoginBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
        [touristLoginBtn setBackgroundColor:FJColorLoginOrange];
        [touristLoginBtn setTitle:@"游客登录" forState:UIControlStateNormal];
        touristLoginBtn.layer.cornerRadius = 3;
        touristLoginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:touristLoginBtn];
        
        [touristLoginBtn addTarget:self action:@selector(onClickTouristLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        [touristLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneRegiterBtn.mas_bottom).offset(15);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.height.mas_equalTo(@40);
            make.width.mas_equalTo(self.contentView).multipliedBy(0.4);
        }];
        
        // 7. touristLoginBtn
        UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setTitleColor:FJBlackTitle forState:UIControlStateNormal];
        [loginBtn setBackgroundColor:FJColorLoginBlue];
        [loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        loginBtn.layer.cornerRadius = 3;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:loginBtn];
        
        [loginBtn addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(phoneRegiterBtn.mas_bottom).offset(15);
            make.right.mas_equalTo(self.contentView).offset(-kMargin);
            make.height.mas_equalTo(@40);
            make.width.mas_equalTo(self.contentView).multipliedBy(0.4);
        }];
        
        // 7.1 line
        UIView* lineLogin = [UIView new];
        lineLogin.backgroundColor = FJColorLightGray;
        [self.contentView addSubview:lineLogin];
        
        [lineLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginBtn).offset(10);
            make.bottom.mas_equalTo(loginBtn).offset(-10);
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(@0.5);
        }];
        
        // 8. noticeTitle
        UILabel* noticeTitle = [[UILabel alloc] init];
        noticeTitle.font = [UIFont fontWithName:@"iconfont" size:20];
        noticeTitle.textColor = FJColorDarkGray;
        noticeTitle.text = @"\U0000e026：";
        [self.contentView addSubview:noticeTitle];
        
        [noticeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(touristLoginBtn.mas_bottom).offset(10);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.width.mas_equalTo(@40).priorityHigh();
            make.height.mas_equalTo(@20);
        }];
        
        
        // 8.1 notice
        FJMarqueeLabel* notice = [[FJMarqueeLabel alloc] init];
        notice.font = [UIFont systemFontOfSize:15];
        notice.textColor = FJColorLightGray;
        notice.text = @"抵制不良游戏 拒绝盗版游戏 注意自我保护 谨防受骗上当 适当游戏有益脑 沉迷游戏伤身 合理安排时间 享受健康生活";
        [self.contentView addSubview:notice];
        
        [notice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(touristLoginBtn.mas_bottom).offset(10);
            make.right.mas_equalTo(self.contentView).offset(-kMargin).priority(1000);
            make.left.mas_equalTo(noticeTitle.mas_right).offset(-2).priority(1000);
            make.height.mas_equalTo(@20);
        }];
        
        // 9.获取登录账号
        [self setCurrentUser:[Utils getCurUser]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    return self;
}

- (void)setAccount:(NSString*)account password:(NSString*)password
{
    self.username.text = account;
    self.password.text = password;
}

#pragma mark - Keyboard notification

- (void)onKeyboardNotification:(NSNotification *)notification
{
    [self closeUserListView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)closeUserListView
{
    [self showUserList:NO];
}

- (void)setCurrentUser:(NSDictionary*)user
{
    if (user != nil)
    {
        NSString *time = [user objectForKey:@"time"];
        NSString *token = [user objectForKey:@"refresh_token"];
        NSString *password = [user objectForKey:@"password"];
        if (time != nil && [time longLongValue] + 2592000 > [[CommTool getTimeStamp] longLongValue]
            && token && [token length] > 0){//30天失效
            self.username.text = [user objectForKey:@"username"];
            self.password.text = password;
        } else {
            self.username.text = [user objectForKey:@"username"];
            self.password.text = @"";
        }
    }
}

#pragma mark - btn click func

- (void)onClickPhoneRegister:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(loginView:onClickPhoneRegister:)]) {
        [_delegate loginView:self onClickPhoneRegister:sender];
    }
}

- (void)onClickForgetPassword:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(loginView:onClickForgetPassword:)]) {
        [_delegate loginView:self onClickForgetPassword:sender];
    }
}

- (void)onClickTouristLogin:(UIButton*)sender
{
    if ([_delegate respondsToSelector:@selector(loginView:onClickTouristLogin:)]) {
        [_delegate loginView:self onClickTouristLogin:sender];
    }
}

- (void)onClickLogin:(UIButton*)sender
{
    NSString* username = self.username.text;
    NSString* password = self.password.text;
    
    if (username == nil || [username isEqualToString:@""]) {
        [CommTool showStaus:@"账号不能为空" withType:TSMessageTypeWarnning];
        return;
    }
    
    if (password == nil || [password isEqualToString:@""]) {
        [CommTool showStaus:@"密码不能为空" withType:TSMessageTypeWarnning];
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(loginView:onClickLogin:username:password:)]) {
        [_delegate loginView:self onClickLogin:sender username:username password:password];
    }
}

- (void)onClickShowUserList:(UIButton*)sender
{
    [self endEditing:YES];
    
    sender.selected = !sender.selected;
    
    BOOL sel = sender.selected;
    [self showUserList:sel];
}

- (void)showUserList:(BOOL)show
{
    self.showUserListBtn.selected = show;
    if (show) {
        TSUserListView* userListView = [TSUserListView new];
        userListView.delegate = self;
        [self addSubview:userListView];
        self.userListView = userListView;
        
        [userListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.username.mas_bottom);
            make.left.mas_equalTo(self.contentView).offset(kMargin);
            make.right.mas_equalTo(self.username);
            make.height.mas_equalTo(@150);
        }];
    } else {
        if (_userListView) {
            [_userListView removeFromSuperview];
        }
    }
}

- (void)onClickShowPassword:(UIButton*)sender
{
    sender.selected = !sender.selected;
    BOOL sel = sender.selected;
    
    self.password.secureTextEntry = !sel;
    NSString* text = self.password.text;
    self.password.text = @" ";
    self.password.text = text;

    if (self.password.secureTextEntry){
        [self.password insertText:self.password.text];
    }
}

//实现代理<UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.password) {
        if (textField.secureTextEntry)
        {
            [textField insertText:self.password.text];
        }
    }
}

#pragma mark - TSUserListViewDelegate
- (void)onUserSelected:(NSInteger)index
{
    NSDictionary *user = [Utils getContentByIndex:index];
    
    [self setCurrentUser:user];
}

- (void)onUserDeleted:(NSString *)username
{
    NSString* usernameLabel = self.username.text;
    if ([usernameLabel isEqualToString:username]) {
        self.username.text = @"";
        self.password.text = @"";
    }
}

- (void)onUserClosed
{
    self.showUserListBtn.selected = !self.showUserListBtn.selected;
}

@end


