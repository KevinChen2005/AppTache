//
//  FJMarqueeLabel.h
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FJMarqueeLabelType) {
    FJMarqueeLabelTypeLeft = 0,//向左边滚动
    FJMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

@interface FJMarqueeLabel : UILabel

@property(nonatomic,unsafe_unretained)FJMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间

@end

