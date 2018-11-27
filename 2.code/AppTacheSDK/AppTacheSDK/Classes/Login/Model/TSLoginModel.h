//
//  TSLoginModel.h
//  AppTache
//
//  Created by admin on 2018/9/19.
//  Copyright © 2018年 com.apptache. All rights reserved.
//  登录结果model，用于记录服务器返回的登录信息

#import "BaseModel.h"

@interface TSLoginModel : BaseModel

SingleH

/**
 *  用户账号
 */
@property(nonatomic,copy) NSString *account;

/**
 *  用户唯一标识
 */
@property(nonatomic,copy) NSString *fid;

/**
 *  手机号
 */
@property(nonatomic,copy) NSString *phone;

/**
 *  token
 */
@property(nonatomic,copy) NSString *token;

/**
 *  密码
 */
@property(nonatomic,copy) NSString *password;

/**
 *  登录消息
 */
@property(nonatomic,copy) NSString *msg;

/**
 *  是否登录成功
 */
@property(nonatomic,assign,getter=isSuccess) BOOL success;

/**
 *  是否绑定手机
 */
@property(nonatomic,assign) BOOL isBindPhone;

/**
 *  支付方式 0-内购 1-H5
 */
@property(nonatomic,assign) NSInteger payType;

- (void)clear;

@end
