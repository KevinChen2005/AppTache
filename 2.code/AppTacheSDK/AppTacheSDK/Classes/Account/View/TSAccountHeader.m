//
//  TSAccountHeader.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#define kHeaderHeight 60

#import "TSAccountHeader.h"

@interface TSAccountHeader()

@property (nonatomic, strong)UILabel* titleLabel;

@end

@implementation TSAccountHeader

+ (instancetype)header
{
    return [[self alloc] init];
}

+ (NSInteger)height
{
    return kHeaderHeight;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = FJColorWhite;
        
        UIView* contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        UILabel* titleLabel = [UILabel new];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(isIpad ? 80 : 30);
            make.top.equalTo(contentView).offset(10);
            make.bottom.equalTo(contentView);
            make.right.equalTo(contentView).offset(10);
        }];
        self.titleLabel = titleLabel;
    }
    
    return self;
}

- (void)setAccount:(NSString *)account
{
    _account = account;
    
    self.titleLabel.text = [NSString stringWithFormat:@"账号：%@", account];
}


@end
