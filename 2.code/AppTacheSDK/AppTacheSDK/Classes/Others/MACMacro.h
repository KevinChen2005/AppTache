//
//  MACMacro.h
//
//  Created by admin on 18/7/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#ifndef MACMacro_h
#define MACMacro_h

//#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"[TSSDK:]%s [Line %d]: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

#define kSdkVersion    @"1.1.0"

#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

//-------------------网络控制----------------
#define DevelopSever    0
#define TestSever       1
#define ProductSever    0

#if DevelopSever
/**开发服务器*/
#define URL_MAIN @"http://134.175.253.24:7001"
#elif TestSever
/**测试服务器*/
#define URL_MAIN @"http://134.175.253.24:7001"
#elif ProductSever
/**生产服务器*/
#define URL_MAIN @"http://134.175.253.24:7001"
#endif
#define kUrl(sub) [NSString stringWithFormat:@"%@/%@", URL_MAIN, sub]

//用户协议URL
#define kUrlUserProtocol @"http://flooringpage.fjszyw.com/readme/contract.html"

//闪屏后启动时间（广告时间）
#define kLaunchCountDown 4

//-------------------颜色和字体----------------
#define FJRGBColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define FJGlobalBG            FJRGBColor(245, 245, 245)
#define FJColorLoginOrange    FJRGBColor(246, 135, 0)
#define FJColorLoginBlue      FJRGBColor(79, 181, 229)
#define FJColorLoginRed       FJRGBColor(243, 0, 0)

#define FJColorWhite          [UIColor whiteColor]
#define FJColorBlack          [UIColor blackColor]
#define FJColorRed            [UIColor redColor]
#define FJColorLightGray      [UIColor lightGrayColor]
#define FJColorDarkGray       [UIColor darkGrayColor]

#define FJBlueStyleColor      FJRGBColor(0x58, 0x81, 0xBF)
#define FJBlackTitle          FJRGBColor(0x33, 0x33, 0x33)
#define FJBlackContent        FJRGBColor(0x66, 0x66, 0x66)
#define FJBlackAuthor         FJRGBColor(0x99, 0x99, 0x99)

#define FJNavbarItemFont [UIFont systemFontOfSize:14]

//--------------------------------------------
#define FJTextSDKName           @"数字游玩手游"
#define FJTextSDKLoginName      @"用户登录"
#define FJTextSDKRegisterName   @"手机注册"
#define FJTextSDKInitPwdTips    @"如未修改初始密码，默认初始密码为666666"
#define FJTextSDKInitPwd        @"666666"

//-----------------iconfont图标-------------
//返回图标-白色
#define kIconFontImageBackWhite  [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e021", 22, FJColorWhite)]
//用户图标-黑色
#define kIconFontImageUserBlack  [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e004", 22, FJColorBlack)]
//修改密码图标
#define kIconFontImageChangePwdBlack [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e003", 22, FJColorBlack)]
//安全图标
#define kIconFontImageSafetyBlack   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e000", 22, FJColorBlack)]
//解绑图标
#define kIconFontImageUnBindBlack   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e005", 22, FJColorBlack)]
//注销图标
#define kIconFontImageLogoutBlack   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e010", 22, FJColorBlack)]
//向下箭头图标
#define kIconFontImageArrowDownGray [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e022", 22, FJColorDarkGray)]
//向上箭头图标
#define kIconFontImageArrowUpGray   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e023", 22, FJColorDarkGray)]
//隐藏密码图标
#define kIconFontImageHidePwdGray   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e025", 22, FJColorDarkGray)]
//显示密码图标
#define kIconFontImageShowPwdGray   [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e024", 22, FJColorDarkGray)]

//富文本编辑 图片标识
#define RICHTEXT_IMAGE (@"[UIImageView]")

//-----------------通知相关宏-------------
#define kNotificationModifyNicknameSuccess  @"kNotificationModifyNicknameSuccess"
#define kNotificationModifyAvatarSuccess    @"kNotificationModifyAvatarSuccess"
#define kNotificationAppWillEnterForeground @"kNotificationAppWillEnterForeground"

//-------------------系统----------------
#pragma mark - 系统
//当前系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//版本判断语句,是否是version以后的
#define IOS(version) (([[[UIDevice currentDevice] systemVersion] intValue] >= version)?1:0)

//获取当前语言
#define CurrentLanguage [[NSLocale preferredLanguages]objectAtIndex:0]

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//-------------------系统----------------
//系统版本
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0
#define IS_IOS_10   floorf([[UIDevice currentDevice].systemVersion floatValue]) ==10.0 ? 1 : 0
#define IS_IOS_11   floorf([[UIDevice currentDevice].systemVersion floatValue]) ==11.0 ? 1 : 0

//-------------------设备相关----------------
#pragma mark - 设备相关
//判断竖屏
#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

#define isIpad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断是什么大小的机型 4，4s ; 5,5s ; 6,6s ; 6+,6+s ; iphoneX
#define iphone4s CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen]currentMode].size)
#define iphone5 CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen]currentMode].size)
#define iphone6 CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen]currentMode].size)
#define iphone6Plus CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen]currentMode].size)

//判断iPhoneX iPhoneXs
#define iphoneX CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size)
//判断iPHoneXr
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isIpad : NO)
#define SCREENSIZE_IS_XR_1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !isIpad : NO)
//判断iPhoneXs Max
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isIpad : NO)

#define IS_IPhoneX_All (iphoneX || SCREENSIZE_IS_XR || SCREENSIZE_IS_XR_1 || SCREENSIZE_IS_XS_MAX)

//获取屏幕宽度、高度
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
//获取屏幕宽度(像素)、高度(像素)
#define kScreenWidthPx (kScreenWidth*[UIScreen mainScreen].scale)
#define kScreenHeightPx (kScreenHeight*[UIScreen mainScreen].scale)

#define ToolBarHeight 49.5
#define kBannerHeight (kScreenWidth*0.45)

//获取状态栏和导航栏高度
#define appStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height
#define appNavigationBarHeight  self.navigationController.navigationBar.frame.size.height

//-------------------设备相关----------------

//-----------------警告处理----------------
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
//-----------------警告处理----------------

#endif /* MACMacro_h */

