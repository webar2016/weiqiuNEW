//
//  WBMyGroupModel.h
//  微球
//
//  Created by 徐亮 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface WBMyGroupModel : NSObject

@property (nonatomic, assign) NSUInteger groupId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSURL *dir;
@property (nonatomic, copy) NSString *isPush;
@property (nonatomic, assign) NSInteger questions;
@property (nonatomic, assign) NSInteger answers;
@property (nonatomic, assign) NSUInteger userId;

@end
