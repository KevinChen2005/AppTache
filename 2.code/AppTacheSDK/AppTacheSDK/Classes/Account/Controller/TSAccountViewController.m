//
//  TSAccountViewController.m
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSAccountViewController.h"
#import "TSAccountModel.h"
#import "TSAccountHeader.h"
#import "TSModifyPasswordViewController.h"
#import "TSBindAccountViewController.h"
#import "TSAccountCell.h"

#define kAccountCellID @"accountCellID"

@interface TSAccountViewController ()

@property (nonatomic, strong)NSMutableArray* datas;

@end

@implementation TSAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"账户";
    
    //获取账号信息，如账号对应的手机绑定信息
    [[SdkManager shareInstance] sdkGetAccountInfo];
    
    self.datas = [NSMutableArray arrayWithCapacity:4];
    self.tableView.rowHeight = 55;
    [self.tableView registerClass:[TSAccountCell class] forCellReuseIdentifier:kAccountCellID];
    
    //设置tableView的头部
    TSAccountHeader* header = [TSAccountHeader header];
    header.account = [TSLoginModel shareInstance].account;
    header.frame = CGRectMake(0, 0, kScreenWidth, [TSAccountHeader height]);
    self.tableView.tableHeaderView = header;
    
    //设置tableView的底部横线
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.6)];
    footer.backgroundColor = FJColorLightGray;
    self.tableView.tableFooterView = footer;
    
    // 1. 关闭按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
    [button.titleLabel setFont:FJNavbarItemFont];
    // 颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e021", 22, FJColorWhite)] forState:UIControlStateNormal];
    [button setImage:[UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e021", 22, FJColorWhite)] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 2. 数据
    
    // 2.1 修改密码
    TSAccountModel* modifyPwd = [TSAccountModel new];
    modifyPwd.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e003", 22, FJColorBlack)];
    modifyPwd.title = @"修改密码";
    modifyPwd.operation = ^(){
        TSModifyPasswordViewController* modifyPwdVC = [TSModifyPasswordViewController new];
        modifyPwdVC.titles = @[@"确认信息", @"设新密码", @"确认修改"];
        [self.navigationController pushViewController:modifyPwdVC animated:YES];
    };
    [self.datas addObject:modifyPwd];
    
    // 2.2 账号安全
    TSAccountModel* accountSecuret = [TSAccountModel new];
    accountSecuret.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e000", 22, FJColorBlack)];
    accountSecuret.title = @"账号安全";
    accountSecuret.operation = ^(){
        TSBindAccountViewController* bindVC = [TSBindAccountViewController new];
        bindVC.titles = @[@"验证身份", @"绑定手机", @"绑定完成"];
        bindVC.title = @"账号安全";
        bindVC.type = TSBindAccountTypeBind;
        [self.navigationController pushViewController:bindVC animated:YES];
    };
    [self.datas addObject:accountSecuret];
    
    // 2.3 账号解绑
    TSAccountModel* unbind = [TSAccountModel new];
    unbind.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e005", 22, FJColorBlack)];
    unbind.title = @"账号解绑";
    unbind.operation = ^(){
        TSBindAccountViewController* unbindVC = [TSBindAccountViewController new];
        unbindVC.titles = @[@"验证身份", @"账号解绑", @"解绑完成"];
        unbindVC.title = @"账号解绑";
        unbindVC.type = TSBindAccountTypeUnBind;
        [self.navigationController pushViewController:unbindVC animated:YES];
    };
    [self.datas addObject:unbind];
    
    // 2.4 注销登录
    TSAccountModel* logout = [TSAccountModel new];
    logout.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e010", 22, FJColorBlack)];
    logout.title = @"注销登录";
    logout.operation = ^(){
        [self logout];
    };
    [self.datas addObject:logout];
}

// 返回按钮操作
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[SdkManager shareInstance] sdkShowFloatView];
}

// 点击注销操作
- (void)logout
{
    [[SdkManager shareInstance] sdkLogout:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:kAccountCellID forIndexPath:indexPath];
    
    TSAccountModel* acc = [self.datas objectAtIndex:indexPath.row];
    cell.account = acc;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TSAccountModel* acc = [self.datas objectAtIndex:indexPath.row];
    if (acc.operation) {
        acc.operation();
    }
}

@end
