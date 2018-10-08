//
//  WKVerCodeImageView.h
//  WKVerCodeView
//
//  Created by Jeaner on 17/5/9.
//  Copyright © 2017年 Jeaner. All rights reserved.
//  图形验证码

#import <UIKit/UIKit.h>

typedef void(^WKCodeImageBlock)(NSString *codeStr);

@interface WKVerCodeImageView : UIView

@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, copy) NSString *imageCodeStr;
@property (nonatomic, copy) WKCodeImageBlock bolck;
@property (nonatomic, strong) UIColor *backColor;

-(void)freshVerCode;

-(void)setVerCode:(NSString*)verCode;

@end
