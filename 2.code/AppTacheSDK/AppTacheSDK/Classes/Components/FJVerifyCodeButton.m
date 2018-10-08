//
//  FJVerifyCodeButton.m
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "FJVerifyCodeButton.h"

@implementation FJVerifyCodeButton

// 开启倒计时效果
- (void)startCountdown
{
    UIButton* btn = self;
    
    UIColor* orgColor = btn.titleLabel.textColor;
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
                [btn setTitleColor:orgColor forState:UIControlStateNormal];
                btn.userInteractionEnabled = YES;
            });
        } else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"剩余%2d秒", seconds] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end

