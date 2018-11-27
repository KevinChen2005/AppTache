//
//  Utils.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "Utils.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <ifaddrs.h>
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

#import "Reachability_funcell.h"

#define IFT_ETHER 0x6
#define USERMAXCOUNT 5
#define kSaveUserInfoFilePlist @"IOS_ZXT_user_store.plist"

@implementation Utils

#pragma mark - 设备信息相关

+ (NSString *)getModel
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    DLog(@"platform:%@",platform);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (CDMA)";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (CDMA)";
    
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (GSM)";
    
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (GSM)";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (GSM)";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (CDMA)";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (4G)";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (4G)";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4";
    
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4";
    
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"iPad6,11"])   return @"iPad(5th generation)";
    
    if ([platform isEqualToString:@"iPad6,12"])   return @"iPad(5th generation)";
    
    if ([platform isEqualToString:@"iPad7,1"])   return @"iPad Pro(12.9-inch,2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,2"])   return @"iPad Pro(12.9-inch,2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,3"])   return @"iPad Pro(10.5-inch,2nd generation)";
    
    if ([platform isEqualToString:@"iPad7,4"])   return @"iPad Pro(10.5-inch,2nd generation)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}
//
//+(NSString *)getModel //设备型号 比如iphone几代
//{
//    NSString *ret = [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].model, [UIDevice currentDevice].localizedModel];
//
//    return ret;
//}

+(NSString *)getVersion //ios系统版本号 比如ios7.0.3
{
    NSString *ret = [NSString stringWithFormat:@"%@%@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
    return ret;
}

+(NSString *)getResolution //屏幕分辨率
{
    CGFloat w = MAX(kScreenWidthPx, kScreenHeightPx);
    CGFloat h = MIN(kScreenWidthPx, kScreenHeightPx);
    
    NSString *ret = [NSString stringWithFormat:@"%0.fx%0.f", w, h];
    return ret;
}

+(NSString *)getDeviceIdentifier //设备唯一标识
{
    return [self getIosDeviceMACAddress:"en0"];
}

+ (NSString*)getIosDeviceMACAddress:(const char *)ifName
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 7) {
        char macAddress[32] = {0};
        
        int success;
        struct ifaddrs * addrs;
        struct ifaddrs * cursor;
        const struct sockaddr_dl *dlAddr;
        const unsigned char* base;
        int i=0;
        
        success = getifaddrs(&addrs) == 0;
        if (success) {
            cursor = addrs;
            while (cursor != 0) {
                if ( (cursor->ifa_addr->sa_family == AF_LINK)
                    && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER) && strcmp(ifName, cursor->ifa_name)==0) {
                    dlAddr = (const struct sockaddr_dl *)cursor->ifa_addr;
                    base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                    strcpy(macAddress, "");
                    for (i = 0; i < dlAddr->sdl_alen; i++) {
                        if (i != 0) {
                            strcat(macAddress, ":");
                        }
                        char partialAddr[3];
                        sprintf(partialAddr, "%02X", base[i]);
                        strcat(macAddress, partialAddr);
                    }
                }
                cursor = cursor->ifa_next;
            }
            freeifaddrs(addrs);
        }
        NSString *strMACAddress = [NSString stringWithUTF8String:macAddress];
        return strMACAddress;
    } else {
        return [self getIdfa];
    }
}

//获取广告标示符
+ (NSString *)getIdfa
{
    NSString *idfa = @"";
    idfa = [NSString stringWithFormat:@"%@",[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
    return idfa;
}

+(NSString *)getDeviceResolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    //分辨率
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%d*%d", (int)(width*scale_screen), (int)(height*scale_screen)];
}

+(NSString *)getDeviceLanguage
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

+(NSString *)getDeviceOperators
{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    if (carrier == nil) {
        return @"未知";
    } else if ([carrier.mobileNetworkCode isEqualToString:@"00"] || [carrier.mobileNetworkCode isEqualToString:@"02"] || [carrier.mobileNetworkCode isEqualToString:@"07"]) {
        return @"中国移动";
    } else if ([carrier.mobileNetworkCode isEqualToString:@"01"] || [carrier.mobileNetworkCode isEqualToString:@"06"]) {
        return @"中国联通";
    } else if ([carrier.mobileNetworkCode isEqualToString:@"03"] || [carrier.mobileNetworkCode isEqualToString:@"05"]) {
        return @"中国电信";
    } else if ([carrier.mobileNetworkCode isEqualToString:@"20"]) {
        return @"中国铁通";
    } else {
        return @"未知";
    }
}

+(NSString *)getNetwork {
    if (IS_IOS_7) {
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        if (networkInfo.currentRadioAccessTechnology == nil) {
            return @"no network";
        } else {
            if ([networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [networkInfo.currentRadioAccessTechnology isEqualToString: CTRadioAccessTechnologyEdge]) {
                return @"2g";
            } else if ([networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                return @"4g";
            } else {
                return @"3g";
            }
        }
    } else {
        NSString *network = @"3g";
        NetworkStatus netStat= [[Reachability_funcell reachabilityForInternetConnection] currentReachabilityStatus];
        if (ReachableViaWiFi == netStat)
            network = @"wifi";
        else if (netStat == ReachableViaWWAN)
            network = @"3g";
        else
            network = @"no network";
        
        return network;
    }
}

+(NSString *)getAppVersion
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString * ver = @"1.0.0";
    if( infoDict != nil)
    {
        ver = [infoDict objectForKey:@"CFBundleShortVersionString"];
    }
    return ver;
}

+(NSString *)md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark - 账号保存相关

+ (NSMutableDictionary *)getContentByIndex:(NSInteger)index
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if( ![fileManager fileExistsAtPath:m_OrderFile])
    {
        return nil;
    }
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile];
    if (data != nil) {
        NSMutableArray *users = [data objectForKey:@"allusers"];
        if (users != nil) {
            if (index < [users count]) {
                return [users objectAtIndex:index];
            }
        }
    }
    
    return nil;
}

+ (void)addContent:(NSString *)username refreshToken:(NSString *)refreshToken time:(NSString *)time password:(NSString*)password
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
    }
    
    if( data == nil)
    {
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableArray *users = [data objectForKey:@"allusers"];
    if (users == nil) {
        users = [[NSMutableArray alloc] init];
    }
    
    for (int i = 0; i < [users count]; ++i) {
        NSMutableDictionary *object = [users objectAtIndex:i];
        if ([[object objectForKey:@"username"] isEqualToString:username]) {
            NSMutableDictionary *newObject = [[NSMutableDictionary alloc] init];
            [newObject setValue:username forKey:@"username"];
            [newObject setValue:refreshToken forKey:@"refresh_token"];
            [newObject setValue:password forKey:@"password"];
            [newObject setValue:time forKey:@"time"];
            
            [users removeObjectAtIndex:i];
            [users insertObject:newObject atIndex:0];
            
            [data setObject:users forKey:@"allusers"];
            [data writeToFile:m_OrderFile atomically:YES];
            
            return;
        } else {
            continue;
        }
    }
    
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    [object setValue:username forKey:@"username"];
    [object setValue:refreshToken forKey:@"refresh_token"];
    [object setValue:password forKey:@"password"];
    [object setValue:time forKey:@"time"];
    
    if ([users count] < USERMAXCOUNT) {
        [users insertObject:object atIndex:0];
    }
    else {
        [users insertObject:object atIndex:0];
        [users removeLastObject];
    }
    
    [data setObject:users forKey:@"allusers"];
    [data writeToFile:m_OrderFile atomically:YES];
    
    
    users = nil;
    data = nil;
}

+ (void)setContentExpired:(NSString *)username //把allusers, curuser, guestuser的password以及refreshtoken清空
{
    //expire allusers
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
    }
    
    if( data == nil)
    {
        return;
    }
    
    NSMutableArray *users = [data objectForKey:@"allusers"];
    if (users != nil) {
        
        for (int i = 0; i < [users count]; ++i) {
            NSMutableDictionary *object = [users objectAtIndex:i];
            if ([[object objectForKey:@"username"] isEqualToString:username]) {
                [object setValue:@"" forKey:@"refresh_token"];
            } else {
                continue;
            }
        }
    }
    ////expire allusers end
    
    //expire curuser
    NSMutableDictionary *curuser = [data objectForKey:@"curuser"];
    if (curuser != nil && [[curuser objectForKey:@"username"] isEqualToString:username])
    {
        [curuser setValue:@"" forKey:@"refresh_token"];
    }
    //expire curuser end
    
    //expire guestuser
    NSMutableDictionary *guestuser = [data objectForKey:@"guestuser"];
    if (guestuser != nil && [[guestuser objectForKey:@"username"] isEqualToString:username])
    {
        [guestuser setValue:@"" forKey:@"password"];
        [guestuser setValue:@"" forKey:@"refresh_token"];
    }
    
    [data writeToFile:m_OrderFile atomically:YES];
    data = nil;
    //expire guestueser end
    
}

+ (void)addCurContent:(NSString *)username password:(NSString *)password refreshToken:(NSString *)refreshToken time:(NSString *)time
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
    }
    
    if( data == nil)
    {
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *curdata = [data objectForKey:@"curuser"];
    if (curdata == nil)
    {
        curdata = [[NSMutableDictionary alloc] init];
        [curdata setValue:username forKey:@"username"];
        [curdata setValue:refreshToken forKey:@"refresh_token"];
        [curdata setValue:password forKey:@"password"];
        [curdata setValue:time forKey:@"time"];
        [data setValue:curdata forKey:@"curuser"];
        [data writeToFile:m_OrderFile atomically:YES];
        
        curdata = nil;
        data = nil;
        return;
    }
    else
    {
        [curdata setValue:username forKey:@"username"];
        [curdata setValue:refreshToken forKey:@"refresh_token"];
        [curdata setValue:password forKey:@"password"];
        [curdata setValue:time forKey:@"time"];
        [data writeToFile:m_OrderFile atomically:YES];
        data = nil;
        return;
    }
}

+ (void)addGuestContent:(NSString *)username password:(NSString *)password refreshToken:(NSString *)refreshToken time:(NSString *)time
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
    }
    
    if( data == nil)
    {
        data = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableDictionary *curdata = [data objectForKey:@"guestuser"];
    if (curdata == nil)
    {
        curdata = [[NSMutableDictionary alloc] init];
        [curdata setValue:username forKey:@"username"];
        [curdata setValue:password forKey:@"password"];
        [curdata setValue:refreshToken forKey:@"refresh_token"];
        [curdata setValue:time forKey:@"time"];
        [data setValue:curdata forKey:@"guestuser"];
        [data writeToFile:m_OrderFile atomically:YES];
        
        curdata = nil;
        data = nil;
        return;
    }
    else
    {
        [curdata setValue:username forKey:@"username"];
        [curdata setValue:password forKey:@"password"];
        [curdata setValue:refreshToken forKey:@"refresh_token"];
        [curdata setValue:time forKey:@"time"];
        [data writeToFile:m_OrderFile atomically:YES];
        data = nil;
        return;
    }
}

+ (void)removeContentByIndex:(int)index
{
    if (index >= USERMAXCOUNT)
        return;
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableArray *users = [data objectForKey:@"allusers"];
            if (users != nil) {
                [users removeObjectAtIndex:index];
                
                [data writeToFile:m_OrderFile atomically:YES];
                data = nil;
            }
        }
    }
}

+ (void)removeContentByUsername:(NSString *)name {
    
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableArray *users = [data objectForKey:@"allusers"];
            if (users != nil) {
                NSEnumerator * enumeratorValue = [users objectEnumerator];
                int i = 0;
                for (NSMutableDictionary *user in enumeratorValue) {
                    NSString *username = [user objectForKey:@"username"];
                    if ([username isEqualToString:name]) {
                        [users removeObject:user];
                        NSString *indexStr = [data objectForKey:@"curindex"];
                        if (indexStr != nil) {
                            if (i < [indexStr intValue]) {
                                [data setObject:[NSString stringWithFormat:@"%d", [indexStr intValue]-1] forKey:@"curindex"];
                            }
                        }
                        break;
                    }
                    ++i;
                }
                
                [data writeToFile:m_OrderFile atomically:YES];
                data = nil;
            }
        }
    }
}

+(NSMutableArray *)getAllUsers
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableArray *users = [data objectForKey:@"allusers"];
            if (users != nil) {
                return users;
            }
        }
    }
    
    return nil;
}

+(NSMutableDictionary *)getCurUser
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableDictionary *curdata = [data objectForKey:@"curuser"];
            if (curdata != nil)
            {
                return curdata;
            }
        }
    }
    
    return nil;
}
+ (void)removeCurContent:(NSString*)name
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableDictionary *curuser = [data objectForKey:@"curuser"];
            if (curuser != nil)
            {
                NSString* username = [curuser objectForKey:@"username"];
                if ([username isEqualToString:name])
                {
                    [curuser removeAllObjects];
                }
            }
            [data writeToFile:m_OrderFile atomically:YES];
            data = nil;
        }
    }
}

+(NSMutableDictionary *)getGuestUser
{
    NSArray * Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString  * path = [Paths objectAtIndex:0];
    NSString * m_OrderFile = [path stringByAppendingPathComponent:kSaveUserInfoFilePlist];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSMutableDictionary * data =nil;
    if( [fileManager fileExistsAtPath:m_OrderFile])
    {
        data = [[[NSMutableDictionary alloc] initWithContentsOfFile:m_OrderFile] mutableCopy];
        if (data != nil) {
            NSMutableDictionary *curdata = [data objectForKey:@"guestuser"];
            if (curdata != nil)
            {
                return curdata;
            }
        }
    }
    
    return nil;
}

+(BOOL) startWith:(NSString*)prefix forString:(NSString*)text
{
    if ( text != nil && prefix != nil ){
        if ( [prefix length] > [text length] ) {
            return NO;
        }
        NSString* prestr = [text substringToIndex:[prefix length]];
        if ([prestr isEqualToString:prefix]) {
            return YES;
        }
    }
    return NO;
}

@end
