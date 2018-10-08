//
//  TSBaseAccountViewController.m
//  AppTache
//
//  Created by admin on 2018/9/17.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSBaseAccountViewController.h"

@interface TSBaseAccountViewController ()

@property (nonatomic, strong)UIView* titleView;

@end

@implementation TSBaseAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = FJColorWhite;
    
    [self buildUI];
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
}

- (void)buildUI
{
    // 1. titleView
    _titleView = [UIView new];
    [self.view addSubview:_titleView];
    [self makeTitlesOfView];
//    self.titleView.backgroundColor = FJColorLoginBlue;
    
    // 2. contentView
    UIView* contentView = [UIView new];
    contentView.backgroundColor = FJRGBColor(245, 245, 245);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleView.mas_bottom);
    }];
}

- (void)makeTitlesOfView
{
    UIView* preView = nil;
    
    NSInteger count = _titles.count;
    for (int i=0; i<count; i++) {
        
        UILabel* label = [UILabel new];
        label.textColor = FJColorDarkGray;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [_titles objectAtIndex:i];
        [_titleView addSubview:label];
        
        UIView* line = [UIView new];
        line.backgroundColor = FJColorLightGray;
        [_titleView addSubview:line];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (preView) {
                make.left.mas_equalTo(preView.mas_right);
            } else {
                make.left.mas_equalTo(self.titleView);
            }
            
            make.top.bottom.mas_equalTo(self.titleView);
            make.width.mas_equalTo(self.titleView.mas_width).dividedBy(count + (count-1)*0.5);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.centerY.mas_equalTo(label.mas_centerY);
            make.height.mas_equalTo(@1);
            make.width.mas_equalTo(label.mas_width).dividedBy(2);
        }];
        
        preView = line;
    }
}

- (void)viewWillLayoutSubviews
{
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (kScreenWidth<kScreenHeight) {
            make.top.mas_equalTo(self.view).offset((iphoneX||isIpad) ? 84 : 64);
        } else {
            make.top.mas_equalTo(self.view).offset((iphoneX||isIpad) ? 55 : 35);
        }
        
        if (self.titles == nil || self.titles.count == 0) {
            make.height.mas_equalTo(@0);
        } else {
            make.height.mas_equalTo(@65);
        }
    }];
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleView.mas_bottom);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end


