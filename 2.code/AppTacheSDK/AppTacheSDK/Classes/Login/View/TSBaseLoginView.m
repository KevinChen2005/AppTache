//
//  TSBaseLoginView.m
//  AppTache
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBaseLoginView.h"

@interface TSBaseLoginView()

@end

@implementation TSBaseLoginView

- (instancetype)init
{
    if (self = [super init]) {
        // 0. 设置背景颜色
        self.backgroundColor = FJColorWhite;
        self.layer.cornerRadius = 10;
        
        // 1. title
        UILabel* baseTitle = [UILabel new];
        [baseTitle setFont:[UIFont systemFontOfSize:20]];
        [baseTitle setTextAlignment:NSTextAlignmentCenter];
        [baseTitle setText:FJTextSDKName];
        [baseTitle setTextColor:FJRGBColor(35, 150, 203)];
        [self addSubview:baseTitle];
        
        [baseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self);
            make.height.equalTo(@50).priorityHigh();
        }];
        
        // 2. 分割线
        UIView* line = [UIView new];
        [line setBackgroundColor:FJColorLightGray];
        [self addSubview:line];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(@0.8).priorityHigh();
            make.top.mas_equalTo(baseTitle.mas_bottom);
        }];
        
        // 3. contentView
        UIView* contentView = [UIView new];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.contentView = contentView;
    }
    
    return self;
}

@end
