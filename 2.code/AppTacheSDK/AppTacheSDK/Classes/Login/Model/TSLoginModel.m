//
//  TSLoginModel.m
//  AppTache
//
//  Created by admin on 2018/9/19.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSLoginModel.h"

@implementation TSLoginModel

SingleM

- (void)setPhone:(NSString *)phone
{
    _phone = [CommTool safeString:phone];
    
    self.isBindPhone = ! [_phone isEqualToString:@""];
}

- (void)setPayType:(NSInteger)payType
{
    _payType = payType;
    
//    _payType = 1; //测试
}

- (void)clear
{
    self.account = @"";
    self.phone = @"";
    self.password = @"";
    self.fid = @"";
    self.token = @"";
    self.msg = @"";
    self.isBindPhone = NO;
    self.success = NO;
}

@end
