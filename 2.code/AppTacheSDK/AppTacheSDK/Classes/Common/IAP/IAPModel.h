//
//  IAPModel.h
//  AppTache
//
//  Created by admin on 2018/9/29.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "BaseModel.h"

@interface IAPModel : BaseModel

@property(nonatomic,copy) NSString *account;       // 用户ID

@property(nonatomic,copy) NSString *orderId;       // 订单号

@property(nonatomic,copy) NSString *receipt;       // 票据(苹果支付成功返回)

@property(nonatomic,copy) NSString *cpOrderId;     // cp订单号

@property(nonatomic,copy) NSString *extInfo;       // 透传参数

@property(nonatomic,copy) NSString *date;          // 日期

@property(nonatomic,copy) NSString *price;         // 单位：分

@property(nonatomic,copy) NSString *payMethodCode; // 支付方式

@end
