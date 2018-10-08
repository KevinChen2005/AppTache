//
//  TSAccountHeader.h
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSAccountHeader : UIView

@property (nonatomic, copy)NSString* account;

+ (instancetype)header;
+ (NSInteger)height;

@end
