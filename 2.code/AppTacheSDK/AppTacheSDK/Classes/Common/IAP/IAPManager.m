//
//  IAPManager.m
//  IAPDemo
//
//  Created by Charles.Yao on 2016/10/31.
//  Copyright © 2016年 com.pico. All rights reserved.
//

#import "IAPManager.h"

static NSString * const receiptKey    = @"receipt";
static NSString * const dateKey       = @"date";
static NSString * const accountKey    = @"account";
static NSString * const orderKey      = @"orderId";
static NSString * const cporderKey    = @"cpOrderNo";
static NSString * const priceKey      = @"price";
static NSString * const extinfoKey    = @"extInfo";
static NSString * const payMethodKey  = @"payMethodCode";

#define kPayMethodApple     @"applepay"
#define kOrderInfofolder    @"orderinfo_folder_147258"

dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_iap_queue;
}

@interface IAPManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL goodsRequestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *receipt; //交易成功后拿到的一个64编码字符串

@property (nonatomic, copy) NSString *date;    //交易时间

@property (nonatomic, copy) NSString *account; //交易人

@property (nonatomic, copy) NSString *orderId; //订单号

@property (nonatomic, copy) NSString *itemId;  //商品id

@property (nonatomic, copy) NSString *cpOrderNo; //cp订单号

@property (nonatomic, copy) NSString *price; //价格，单位：分

@property (nonatomic, copy) NSString *extInfo; //透传参数

@property (nonatomic, strong) NSDictionary* orderInfo;

@end

@implementation IAPManager

SingleM

- (void)startManager { //开启监听
    
    self.account = [TSLoginModel shareInstance].account;

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.goodsRequestFinished = YES;
    
    dispatch_async(iap_queue(), ^{
        
        /***
         内购支付两个阶段：
         1.app直接向苹果服务器请求商品，支付阶段；
         2.苹果服务器返回凭证，app向公司服务器发送验证，公司再向苹果服务器验证阶段；
         */
        
        /**
         阶段一正在进中,app退出。
         在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
         */
    
        
        /**
         阶段二正在进行中,app退出。
         在程序启动时，检测本地是否有receipt文件，有的话，去二次验证。
         */
        [self checkIAPFiles:YES];
    });
}

- (void)stopManager{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

#pragma mark 查询
- (void)requestProductWithId:(NSString *)productId orderId:(NSString*)orderId account:(NSString*)account cpOrderNo:(NSString*)cpOrderNo price:(NSString*)price extInfo:(NSString*)extInfo {
    
    self.account = [CommTool safeString:account];
    self.orderId = [CommTool safeString:orderId];
    self.itemId  = [CommTool safeString:productId];
    self.cpOrderNo = [CommTool safeString:cpOrderNo];
    self.extInfo = [CommTool safeString:extInfo];
    self.price   = [CommTool safeString:price];
    
    self.orderInfo =[NSDictionary dictionaryWithObjectsAndKeys:
                                         self.orderId,             orderKey,
                                         self.cpOrderNo,           cporderKey,
                                         self.extInfo,             extinfoKey,
                                         self.price,               priceKey,
                                       kPayMethodApple,            payMethodKey,
                                         nil];
    
    [self saveOrderInfo];

    if (self.goodsRequestFinished) {
       
        if ([SKPaymentQueue canMakePayments]) { //用户允许app内购
            
            if (productId.length) {
               
                NSLog(@"productId: %@ - 商品正在请求中",productId);
               
                self.goodsRequestFinished = NO; //正在请求
               
                NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
                
                NSSet *set = [NSSet setWithArray:product];
               
                SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
               
                productRequest.delegate = self;
               
                [productRequest start];
            
            } else {
               
                NSLog(@"商品为空");
                
                [self failedWithErrorCode:IAP_FILEDCOED_EMPTYGOODS error:nil];
                
                self.goodsRequestFinished = YES; //完成请求
            }
        
        } else { //没有权限
            
            [self failedWithErrorCode:IAP_FILEDCOED_NORIGHT error:nil];
            
            self.goodsRequestFinished = YES; //完成请求
        }
    
    } else {

        NSLog(@"上次请求还未完成，请稍等");
        
        [self failedWithErrorCode:IAP_FILEDCOED_UNKNOW error:nil];
    }
}

#pragma mark SKProductsRequestDelegate 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    NSArray *product = response.products;
    
    if (product.count == 0) {
        
        NSLog(@"无法获取商品信息，请重试");
        
        [self failedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION error:nil];
        
        self.goodsRequestFinished = YES; //失败，请求完成

    } else {
        
        NSLog(@"-----------收到产品反馈信息--------------");
        NSArray *myProduct = response.products;
        NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
        NSLog(@"产品付费数量: %d", (int)[myProduct count]);    // populate UI
        for(SKProduct *product in myProduct){
            NSLog(@"product info");
            NSLog(@"SKProduct 描述信息%@", [product description]);
            NSLog(@"产品标题 %@" , product.localizedTitle);
            NSLog(@"产品描述信息: %@" , product.localizedDescription);
            NSLog(@"价格: %@" , product.price);
            NSLog(@"Product id: %@" , product.productIdentifier);
        }
        
        //发起购买请求
        SKPayment *payment = [SKPayment paymentWithProduct:product[0]];
       
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

#pragma mark SKProductsRequestDelegate 查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    [self failedWithErrorCode:IAP_FILEDCOED_APPLECODE error:[error localizedDescription]];
    
    self.goodsRequestFinished = YES; //失败，请求完成
}

#pragma Mark 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {

    for (SKPaymentTransaction *transaction in transactions) {
       
        switch (transaction.transactionState) {
           
            case SKPaymentTransactionStatePurchasing://正在交易
               
                break;

            case SKPaymentTransactionStatePurchased://交易完成
                
                //判断为上次app意外退出后用户支付成功，这次开启监听后收到支付成功回调
                if (self.orderInfo == nil) {
                    [self checkOrderInfoFiles];
                }
                
                [self removeOrderInfoFiles];
                
                [self getReceipt]; //获取交易成功后的购买凭证
               
                [self saveReceipt]; //存储交易凭证
               
                [self checkIAPFiles:NO];//把self.receipt发送到服务器验证是否有效
                
                [self completeTransaction:transaction];
                
                break;

            case SKPaymentTransactionStateFailed://交易失败
               
                [self failedTransaction:transaction];
                
                break;

            case SKPaymentTransactionStateRestored://已经购买过该商品
                
                [self restoreTransaction:transaction];
                
                break;
           
            default:
               
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    self.goodsRequestFinished = YES; //成功，请求完成
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {

    DLog(@"transaction.error.code = %ld", (long)transaction.error.code);
    
    

    if(transaction.error.code != SKErrorPaymentCancelled) {

        [self failedWithErrorCode:IAP_FILEDCOED_BUYFILED error:nil];

    } else {

        [self failedWithErrorCode:IAP_FILEDCOED_USERCANCEL error:nil];
    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
   
    self.goodsRequestFinished = YES; //失败，请求完成

}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    self.goodsRequestFinished = YES; //恢复购买，请求完成

}

////////////////////////////////////////

-(void)saveOrderInfo {
    
    NSString *fileName = self.orderId;
    
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [SandBoxHelper iapReceiptAccountPath:kOrderInfofolder], fileName];
    
    NSLog(@"orderInfo savedPath = %@", savedPath);
    
    [self.orderInfo writeToFile:savedPath atomically:YES];
}

- (void)checkOrderInfoFiles{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[SandBoxHelper iapReceiptAccountPath:kOrderInfofolder] error:&error];
    
    if (error == nil) {
        
        for (NSString *name in cacheFileNameArray) {
            
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
                
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [SandBoxHelper iapReceiptAccountPath:kOrderInfofolder], name];
                NSLog(@"filePath=%@", filePath);
                
                self.orderInfo = [[NSDictionary alloc] initWithContentsOfFile:filePath];
                
                self.orderId = self.orderInfo[orderKey];
                self.cpOrderNo = self.orderInfo[cporderKey];
                self.extInfo = self.orderInfo[extinfoKey];
                self.price = self.orderInfo[priceKey];
                
            }
        }
        
    } else {
        
        NSLog(@"OrderInfoLocalFilePath error:%@", [error domain]);
    }
}

-(void)removeOrderInfoFiles {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[SandBoxHelper iapReceiptAccountPath:kOrderInfofolder]]) {
        
        [fileManager removeItemAtPath:[SandBoxHelper iapReceiptAccountPath:kOrderInfofolder] error:nil];
        
    }
}

////////////////////////////////////////

#pragma mark 获取交易成功后的购买凭证

- (void)getReceipt {

    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
   
    self.receipt = [receiptData base64EncodedStringWithOptions:0];
}

#pragma mark  持久化存储用户购买凭证(这里最好还要存储当前日期，用户id等信息，用于区分不同的凭证)
-(void)saveReceipt {

    self.date = [NSDate chindDateFormate:[NSDate date]];
    
    NSString *fileName = self.orderId;
   
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [SandBoxHelper iapReceiptAccountPath:self.account], fileName];
    
    NSLog(@"savedPath = %@", savedPath);
    
    NSDictionary *dic =[NSDictionary dictionaryWithObjectsAndKeys:
                        self.receipt,             receiptKey,
                        self.date,                dateKey,
                        self.account,             accountKey,
                        self.orderId,             orderKey,
                        self.cpOrderNo,           cporderKey,
                        self.extInfo,             extinfoKey,
                        self.price,               priceKey,
                        kPayMethodApple,          payMethodKey,
                        nil];
   
    NSLog(@"%@",savedPath);
    
    [dic writeToFile:savedPath atomically:YES];
}

#pragma mark 将存储到本地的IAP文件发送给服务端 验证receipt失败,App启动后再次验证
- (void)checkIAPFiles:(BOOL)isRepaire {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
   
    //搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[SandBoxHelper iapReceiptAccountPath:self.account] error:&error];
    
    if (error == nil) {
       
        for (NSString *name in cacheFileNameArray) {
            
            if (isRepaire) {
                [CommTool showStaus:@"检测到未完成订单，正在补单..." withType:TSMessageTypeInfo];
            }
            
            if ([name hasSuffix:@".plist"]){ //如果有plist后缀的文件，说明就是存储的购买凭证
               
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [SandBoxHelper iapReceiptAccountPath:self.account], name];
                NSLog(@"filePath=%@", filePath);
                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }
    
    } else {
       
        NSLog(@"AppStoreInfoLocalFilePath error:%@", [error domain]);
    }
}

-(void)sendAppStoreRequestBuyPlist:(NSString *)plistPath {

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    //回调验证
    if ([self.delegate respondsToSelector:@selector(successWithReceipt:)]) {
        [self.delegate successWithReceipt:dic];
    }
}


//验证成功就从plist中移除凭证
-(void)removeReceipt{
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
   
    if ([fileManager fileExistsAtPath:[SandBoxHelper iapReceiptAccountPath:self.account]]) {
        
        [fileManager removeItemAtPath:[SandBoxHelper iapReceiptAccountPath:self.account] error:nil];
    
    }
}


#pragma mark 错误信息反馈
- (void)failedWithErrorCode:(NSInteger)code error:(NSString *)error {

    // 如果订单信息为nil，则判断为进入游戏开启监听收到上次app意外退出时的用户取消或支付失败的回调，可以不作处理
    if (self.orderInfo == nil) {
        DLog(@"收到上次app意外退出用户取消支付或支付失败回调");
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(failedWithErrorCode:andError:orderInfo:)]) {
        switch (code) {
            case IAP_FILEDCOED_APPLECODE:
                [self.delegate failedWithErrorCode:IAP_FILEDCOED_APPLECODE andError:error orderInfo:self.orderInfo];
                break;

                case IAP_FILEDCOED_NORIGHT:
                [self.delegate failedWithErrorCode:IAP_FILEDCOED_NORIGHT andError:nil orderInfo:self.orderInfo];
                break;

            case IAP_FILEDCOED_EMPTYGOODS:
                [self.delegate failedWithErrorCode:IAP_FILEDCOED_EMPTYGOODS andError:nil orderInfo:self.orderInfo];
                break;

            case IAP_FILEDCOED_CANNOTGETINFORMATION:
                 [self.delegate failedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION andError:nil orderInfo:self.orderInfo];
                break;

            case IAP_FILEDCOED_BUYFILED:
                 [self.delegate failedWithErrorCode:IAP_FILEDCOED_BUYFILED andError:nil orderInfo:self.orderInfo];
                break;

            case IAP_FILEDCOED_USERCANCEL:
                 [self.delegate failedWithErrorCode:IAP_FILEDCOED_USERCANCEL andError:nil orderInfo:self.orderInfo];
                break;

            default:
                break;
        }
    }
}

@end
