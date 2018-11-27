//
//  TSAppstorePay.m
//  AppTache
//
//  Created by admin on 17/6/15.
//  Copyright © 2017年 zzw. All rights reserved.
//

#import "TSAppstorePay.h"
#import "IAPManager.h"
#import "IAPModel.h"

@interface TSAppstorePay() <IApRequestResultsDelegate>

@end

static TSAppstorePay* FCshareView = nil;

@implementation TSAppstorePay

+(TSAppstorePay*) shareInstace
{
    @synchronized(self){
        if( FCshareView == nil)
        {
            FCshareView = [[self alloc] init];
        }
    }
    return  FCshareView;
}

-(id)init
{
    if (self = [super init]){
    }
    return self;
}

//释放
-(void)dealloc
{
    [[IAPManager shareInstance] stopManager];
}

//初始化
-(void)initialStorePay
{
    [[IAPManager shareInstance] setDelegate:self];
    [[IAPManager shareInstance] startManager];
}

- (void)SDKWorkWithParams:(NSDictionary *)params
{
    NSString * itemId    = [params objectForKey:@"itemId"];
    NSString * price     = [params objectForKey:@"price"];
    NSString * orderId   = [params objectForKey:@"orderId"];
    NSString * extInfo   = [params objectForKey:@"extInfo"];     //保存下来，支付成功回调
    NSString * cpOrderId = [params objectForKey:@"cpOrderId"];   //保存下来，支付成功回调
    NSString * account   = [TSLoginModel shareInstance].account;
    
    [FJProgressHUB showWithMaskMessage:nil];
    
    // 传入订单账号信息，防止支付成功掉单后补单验单时信息不对称
    [[IAPManager shareInstance] requestProductWithId:itemId orderId:orderId account:account cpOrderId:cpOrderId price:price extInfo:extInfo];
}

#pragma mark IApRequestResultsDelegate
- (void)failedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error orderInfo:(NSDictionary *)orderInfo
{
    [FJProgressHUB dismiss];
    
    NSMutableDictionary* resultDict = nil;
    if (orderInfo) {
        resultDict = [NSMutableDictionary dictionaryWithDictionary:orderInfo];
    } else {
        resultDict = [NSMutableDictionary dictionary];
    }
    
    [resultDict setObject:@0 forKey:@"success"];
    
    NSString* msg = @"";
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            msg = @"苹果购买失败";
            DLog(@"%@:%@", msg, error);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapFail:resultDict];
            break;
            
        case IAP_FILEDCOED_NORIGHT:
            msg = @"用户禁止应用内付费购买";
            DLog(@"%@", msg);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapFail:resultDict];
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
            msg = @"商品为空";
            DLog(@"%@", msg);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapFail:resultDict];
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            msg = @"无法获取商品信息";
            DLog(@"%@", msg);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapFail:resultDict];
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            msg = @"购买失败，请重试";
            DLog(@"%@", msg);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapFail:resultDict];
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            msg = @"用户取消交易";
            DLog(@"%@", msg);
            [CommTool showStaus:msg withType:TSMessageTypeInfo];
            [resultDict setObject:msg forKey:@"msg"];
            [self iapCancel:resultDict];
            break;
            
        default:
            break;
    }
}

- (void)successWithReceipt:(NSDictionary *)receiptDict
{
    DLog(@"success");
    
    IAPModel* iapmodel = [IAPModel fj_objectWithDictionary:receiptDict];
    
    NSString* account    = [CommTool safeString:iapmodel.account];
    NSString* extInfo    = [CommTool safeString:iapmodel.extInfo];
    NSString* cpOrderId  = [CommTool safeString:iapmodel.cpOrderId];
    NSString* orderId    = [CommTool safeString:iapmodel.orderId];
    NSString* receipt    = [CommTool safeString:iapmodel.receipt];
    NSString* price      = [CommTool safeString:iapmodel.price];
    NSString* payMethodCode  = [CommTool safeString:iapmodel.payMethodCode];
    NSString* token      = [CommTool safeString:[TSLoginModel shareInstance].token];
    NSString* gameCode   = [CommTool safeString:[TSAppModel shareInstance].gameCode];
    NSString* platformId = [CommTool safeString:[TSAppModel shareInstance].platformId];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:account forKey:@"account"];
    [params setObject:orderId forKey:@"orderId"];
    [params setObject:receipt forKey:@"receipt"];
    [params setObject:account forKey:@"account"];
    [params setObject:token   forKey:@"token"];
    
    [params setObject:gameCode   forKey:@"gameCode"];
    [params setObject:platformId forKey:@"platformId"];
    
    DLog(@"checkIapReceipt params=%@", params);
    
    WEAKSELF
    [HttpTool checkIapReceipt:params success:^(id retObj) {
        STRONGSELF
        DLog(@"retObj=%@", retObj);
        
        [FJProgressHUB dismiss];
        
        NSDictionary* dictRet = @{
                                  @"orderId"    :  orderId,
                                  @"cpOrderId"  :  cpOrderId,
                                  @"extInfo"    :  extInfo,
                                  @"price"      :  price,
                                  @"payMethodCode"    :  payMethodCode,
                                  };
        
        [strongSelf checkResult:retObj withRetDict:dictRet];

    } failure:^(NSError *error) {
        [FJProgressHUB dismiss];
        
        DLog(@"充值链接超时,请重试!");
        [CommTool showStaus:@"充值链接超时,请重试!" withType:TSMessageTypeError];
    }];
}

- (void)checkResult:(id)retObj withRetDict:(NSDictionary*)dictRet
{
    NSDictionary* retDict = nil;
    if (retObj && [retObj isKindOfClass:[NSString class]]) {
        retDict = [NSDictionary dictionaryWithJsonString:retObj];
    } else if(retObj && [retObj isKindOfClass:[NSDictionary class]]) {
        retDict = retObj;
    }
    
    if (retDict == nil) {
        [CommTool showStaus:@"验单失败，数据格式错误" withType:TSMessageTypeError];
        return;
    }
    
    NSInteger success = [retDict[@"success"] integerValue];
    NSString* msg = retDict[@"msg"];
    
    NSMutableDictionary* finalDict = [NSMutableDictionary dictionaryWithDictionary:dictRet];
    [finalDict setObject:[CommTool safeString:msg] forKey:@"msg"];
    [finalDict setObject:@(success) forKey:@"success"];
    
    switch (success) {
        case 1: // 校验成功
        {
            msg = @"支付成功";
            
            [self dealSuccessMessage:msg finalDict:finalDict];
        }
            break;
            
        case 0: // 校验失败
        {
            msg = @"支付失败, 校验票据失败";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:NO];
        }
            break;
        case 2: // 未查询到订单
        {
            msg = @"支付失败，未查询到订单";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:YES];
        }
            break;
        case 3: // 订单已经校验过
        {
            msg = @"支付失败，订单已经校验过";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:YES];
        }
            break;
        case 4: // 无此订单支付信息
        {
            msg = @"支付失败，无此订单支付信息";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:YES];
        }
            break;
        case 5: // 凭证无效
        {
            msg = @"支付失败，凭证无效";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:YES];
        }
            break;
        case 6: // receipt凭证不正确
        {
            msg = @"支付失败，凭证不正确";
            
            [self dealFailMessage:msg finalDict:finalDict isDeleteReceipt:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealSuccessMessage:(NSString*)msg finalDict:(NSDictionary*)finalDict
{
//    [CommTool showStaus:msg withType:TSMessageTypeInfo];
    
    [self iapSuccess:finalDict];
    
    // 删除本地票据
    [[IAPManager shareInstance] removeReceipt];
}

- (void)dealFailMessage:(NSString*)msg finalDict:(NSDictionary*)finalDict isDeleteReceipt:(BOOL)isDelete
{
//    [CommTool showStaus:msg withType:TSMessageTypeError];
    
    [self iapFail:finalDict];
    
    if (isDelete) {
        // 删除本地票据
        [[IAPManager shareInstance] removeReceipt];
    }
}

- (void)stopStorePay
{
    [[IAPManager shareInstance] stopManager];
}

#pragma mark - iap trade callback

- (void)iapSuccess:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(TSAppPaySuccessCallBack:)]) {
        [_delegate TSAppPaySuccessCallBack:result];
    }
}

- (void)iapFail:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(TSAppPayFailCallBack:)]) {
        [_delegate TSAppPayFailCallBack:result];
    }
}

- (void)iapCancel:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(TSAppPayCancelCallBack:)]) {
        [_delegate TSAppPayCancelCallBack:result];
    }
}

- (void)iapClose:(NSDictionary*)result
{
    if ([_delegate respondsToSelector:@selector(TSAppPayClosePayPage:)]) {
        [_delegate TSAppPayClosePayPage:result];
    }
}

@end
