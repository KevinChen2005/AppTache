//
//  TSAccountModel.h
//  AppTache
//
//  Created by admin on 2018/9/15.
//  Copyright © 2018年 com.apptache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAccountModel : NSObject

@property (nonatomic, strong)UIImage* image;

@property (nonatomic, copy)NSString* title;

@property (nonatomic, copy)void (^operation)(void);

@end
