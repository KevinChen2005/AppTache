//
//  TSIconView.m
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSIconView.h"

@interface TSIconView ()

@property (nonatomic, strong)UIImageView* imageView;

@end

@implementation TSIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 设置背景颜色
        self.backgroundColor = FJColorWhite;
        
        // 添加图片控件
        UIImageView* imageView = [UIImageView new];
        [self addSubview:imageView];
        
        CGFloat margin = 3.0;
        imageView.frame = CGRectMake(margin, margin, frame.size.width - margin*2, frame.size.height - margin*2);
        
        //将多余的部分切掉
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5;
        imageView.layer.masksToBounds = YES;
        
        self.imageView = imageView;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    if (image) {
        self.imageView.image = image;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

@end
