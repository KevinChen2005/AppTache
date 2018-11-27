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

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self onClickInitBtn:nil];
}

- (IBAction)onClickInitBtn:(id)sender
{
    [[AppTacheSDK sharedInstance] setDelegate:self]; // 在调用初始化接口之前调用，不然可能收不到初始化回调
    [[AppTacheSDK sharedInstance] initSdkWithGameCode:@"OGjIDRXJ1p" platformId:@"1000"];
}

- (IBAction)onClickLoginBtn:(id)sender
{
    [[AppTacheSDK sharedInstance] login];
}

- (IBAction)onClickPayBtn:(id)sender
{
    NSString* cpOrderId = [NSString stringWithFormat:@"zxt%d", (arc4random() % 1000001) + 9000000];
    NSString* itemId     = @"com.xsm2.10"; //资讯通
    NSString* itemName   = @"10元宝";
    NSString* currency   = @"CNY";
    NSString* price      = @"1"; //单位：分
    NSString* roleId     = @"role_000111";
    NSString* roleName   = @"风情剑客";
    NSString* serverId   = @"1001";
    NSString* serverName = @"桃花源";
    NSString* extInfo    = @"extInfo"; //透传参数
    
    NSDictionary* params = @{
                             @"itemId"      :  itemId,
                             @"itemName"    :  itemName,
                             @"currency"    :  currency,
                             @"price"       :  price,
                             @"cpOrderId"   :  cpOrderId,
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
    NSLog(@"AppTacheSDK init success, sdk version: %@", [[AppTacheSDK sharedInstance] getSdkVersion]);
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

- (void)appTacheSdkDidPayCancel:(NSDictionary *)result
{
    NSLog(@"AppTacheSDK pay canceled, result = %@", result);
}

@end

