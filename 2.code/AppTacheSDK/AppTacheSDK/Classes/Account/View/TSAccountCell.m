//
//  TSAccountCell.m
//  AppTache
//
//  Created by admin on 2018/9/28.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSAccountCell.h"
#import "TSAccountModel.h"

@interface TSAccountCell()

//@property (nonatomic, strong)UIImageView* iconView;
//
//@property (nonatomic, strong)UILabel* titleLabel;

@end

@implementation TSAccountCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

//    // 1. iconView
//    UIImageView* iconView = [[UIImageView alloc] init];
//    [self.contentView addSubview:iconView];
//    self.iconView = iconView;
//
//    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView).offset(50);
//        make.top.mas_equalTo(self.contentView).offset(10);
//        make.bottom.mas_equalTo(self.contentView).offset(-10);
//        make.width.mas_equalTo(iconView.mas_height);
//    }];
//
//    // 2. titleLabel
//    UILabel* titleLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:titleLabel];
//    self.titleLabel = titleLabel;
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.iconView.mas_right).offset(40);
//        make.top.mas_equalTo(self.contentView).offset(10);
//        make.bottom.mas_equalTo(self.contentView).offset(-10);
//        make.right.mas_equalTo(self.contentView).offset(40);
//    }];
}

- (void)setAccount:(TSAccountModel *)account
{
    _account = account;
    
//    self.titleLabel.text = [account title];
//    self.iconView.image = [account image];
    
    self.textLabel.text = [account title];
    self.imageView.image = [account image];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
