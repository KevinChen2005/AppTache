//
//  TSUserListView.h
//  AppTache
//
//  Created by admin on 2018/9/18.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TSUserListViewDelegate;

@interface TSUserListView : UIView

@property (nonatomic, weak)id<TSUserListViewDelegate> delegate;

@end

@protocol TSUserListViewDelegate <NSObject>

@optional

-(void)onUserSelected:(NSInteger)index;
-(void)onUserDeleted:(NSString *)username;
-(void)onUserClosed;

@end
