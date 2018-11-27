//
//  TSUserListView.m
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import "TSUserListView.h"

#define CELLHEIGHT (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone?45.0f:70.0f)

@interface TSUserListView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation TSUserListView

- (instancetype)init
{
    if (self = [super init]) {
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.3;
        self.layer.borderColor = FJColorLightGray.CGColor;
        
        // 1. title
        _dataList = [NSMutableArray array];
        NSArray* array = [Utils getAllUsers];
        for (NSMutableDictionary *user in array) {
            NSString* phone = [user objectForKey:@"phone"];
            NSString* username = [user objectForKey:@"username"];
            if (phone && ![phone isEqualToString:@""]) {
                [_dataList addObject:phone];
            } else {
                [_dataList addObject:username];
            }
        }
        [_dataList addObject:NSLocalizedString(@"关闭", nil)];
        
        // 2. tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [_tableView setEditing:YES animated:NO];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelectionDuringEditing = YES;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
        
        // 3. footer
        UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.4)];
        footer.backgroundColor = FJColorLightGray;
        self.tableView.tableFooterView = footer;
    }
    
    return self;
}

#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    NSString *a = [_dataList objectAtIndex:row];
    cell.textLabel.text = a;
    
    if (indexPath.row == self.dataList.count - 1) {//最后一行为关闭
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return cell;
}

// 点击删除某一行后回调
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *username = [_dataList objectAtIndex:indexPath.row];
        [_dataList removeObjectAtIndex:indexPath.row];
        [Utils removeContentByIndex:indexPath.row];
        [Utils removeCurContent:username];
        //[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView reloadData];
        
        if ([_delegate respondsToSelector:@selector(onUserDeleted:)]) {
            [_delegate onUserDeleted:username];
        }
        
        if ([_dataList count] <= 1)
            [self onClose];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //最后一行为关闭，不允许删除
    if (indexPath.row < [_dataList count] - 1)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [_dataList count] - 1) {//关闭
        if ([_delegate respondsToSelector:@selector(onUserSelected:)]) {
            [_delegate onUserSelected:indexPath.row];
        }
    }
    [self onClose];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

//当 tableview 为 editing 时,左侧按钮的 style
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// 关闭账号列表
-(void)onClose
{
    [self removeFromSuperview];
    
    //回调
    if ([_delegate respondsToSelector:@selector(onUserClosed)]) {
        [_delegate onUserClosed];
    }
}

@end
