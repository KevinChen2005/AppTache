//
//  TSGameCenterToolbarView.h
//  AppTache
//
//  Created by niko on 18-7-18.
//  Copyright (c) 2018年 niko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSGameCenterToolbarViewDelegate;

@interface TSGameCenterToolbarView : UIView

@property (nonatomic, weak)id<TSGameCenterToolbarViewDelegate> delegate;

- (void)initView;
- (void)settoolbarpoint:(CGPoint)point;

@end

@protocol TSGameCenterToolbarViewDelegate <NSObject>

- (void)floatView:(TSGameCenterToolbarView*)floatView didClickMenuAccount:(id)sender;

@end
