//
//  IAPModel.h
//  AppTache
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "BaseModel.h"

@interface IAPModel : BaseModel

@property(nonatomic,copy) NSString *account;

@property(nonatomic,copy) NSString *orderId;

@property(nonatomic,copy) NSString *receipt;

@property(nonatomic,copy) NSString *cpOrderNo;

@property(nonatomic,copy) NSString *extInfo;

@property(nonatomic,copy) NSString *date;

@property(nonatomic,copy) NSString *price; // 单位：分

@property(nonatomic,copy) NSString *payMethodCode; // 支付方式

@end
