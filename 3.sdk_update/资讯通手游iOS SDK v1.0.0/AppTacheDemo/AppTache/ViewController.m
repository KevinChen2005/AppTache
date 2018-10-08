//
//  ViewController.m
//  AppTache
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "ViewController.h"
#import <AppTacheSDK/AppTacheSDK.h>

@interface ViewController () <AppTacheSDKDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [AppTacheSDK sharedInstance].delegate = self;
    
    [self onClickInitBtn:nil];
}

- (IBAction)onClickInitBtn:(id)sender
{
    [[AppTacheSDK sharedInstance] initSdkWithGameCode:@"OGjIDRXJ1p" platformId:@"1000"];
}

- (IBAction)onClickLoginBtn:(id)sender
{
    [[AppTacheSDK sharedInstance] login];
}

- (IBAction)onClickPayBtn:(id)sender
{
    NSString* cpOrderNo = [NSString stringWithFormat:@"zxt%d", (arc4random() % 1000001) + 9000000];
    NSString* itemId     = @"xxlyf.648";//@"com.xsm2.10"; //商品id
    NSString* itemName   = @"10元宝"; //商品名称
    NSString* currency   = @"CNY";  //货币类型
    NSString* money      = @"0.01"; //单位：元
    NSString* roleId     = @"role_000111"; //角色id
    NSString* roleName   = @"风情剑客"; //角色名称
    NSString* serverId   = @"1001";  //服务器id
    NSString* serverName = @"桃花源"; //服务器名称
    NSString* extInfo    = @"extInfo"; //透传参数
    
    NSDictionary* params = @{
                             @"itemId"      :  itemId,
                             @"itemName"    :  itemName,
                             @"currency"    :  currency,
                             @"money"       :  money,
                             @"cpOrderNo"   :  cpOrderNo,
                             @"roleId"      :  roleId,
                             @"roleName"    :  roleName,
                             @"serverId"    :  serverId,
                             @"serverName"  :  serverName,
                             @"extInfo"     :  extInfo
                             };
    
    [[AppTacheSDK sharedInstance] requestPay:params];
}

- (IBAction)onClickLogoutBtn:(id)sender
{
    [[AppTacheSDK sharedInstance] logout];
}

- (IBAction)onClickCreateRole:(id)sender
{
    NSString* roleId     = @"role_000111";
    NSString* roleName   = @"风情剑客";
    NSString* serverId   = @"1001";
    NSString* serverName = @"桃花源";
    
    NSDictionary* params = @{
                             @"cpRoleId"      :  roleId,
                             @"cpRoleName"    :  roleName,
                             @"cpServerId"    :  serverId,
                             @"cpServerName"  :  serverName,
                             };
    
    [[AppTacheSDK sharedInstance] addDataType:ATDataTypeCreateRole params:params];
}

- (IBAction)onClickEnterGame:(id)sender
{
    NSString* roleId     = @"role_000111";
    NSString* roleName   = @"风情剑客";
    NSString* serverId   = @"1001";
    NSString* serverName = @"桃花源";
    
    NSDictionary* params = @{
                             @"cpRoleId"      :  roleId,
                             @"cpRoleName"    :  roleName,
                             @"cpServerId"    :  serverId,
                             @"cpServerName"  :  serverName,
                             };
    
    [[AppTacheSDK sharedInstance] addDataType:ATDataTypeEnterGame params:params];
}

- (IBAction)onClickLevelUp:(id)sender
{
    NSString* roleId     = @"role_000111";
    NSString* roleName   = @"风情剑客";
    NSString* serverId   = @"1001";
    NSString* serverName = @"桃花源";
    NSNumber* level      = @10;
    
    NSDictionary* params = @{
                             @"cpRoleId"      :  roleId,
                             @"cpRoleName"    :  roleName,
                             @"cpServerId"    :  serverId,
                             @"cpServerName"  :  serverName,
                             @"level"         :  level,
                             };
    
    [[AppTacheSDK sharedInstance] addDataType:ATDataTypeLevelUp params:params];
}

#pragma mark - AppTacheSDKDelegate

- (void)appTacheSdkDidInitSuccess
{
    NSLog(@"AppTacheSDK init success");
}

- (void)appTacheSdkDidLoginSuccess:(NSDictionary *)result
{
    NSLog(@"AppTacheSDK login success, result = %@", result);
}

- (void)appTacheSdkDidLogoutSuccess
{
    NSLog(@"AppTacheSDK logout success");
}

- (void)appTacheSdkDidPaySuccess:(NSDictionary *)result
{
    NSLog(@"AppTacheSDK pay success, result = %@", result);
}

- (void)appTacheSdkDidPayFailed:(NSDictionary *)result
{
    NSLog(@"AppTacheSDK pay failed, result = %@", result);
}

@end

