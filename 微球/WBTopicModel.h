//
//  WBTopicModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTopicModel : NSObject
@property (assign ,nonatomic) NSInteger topicId;
@property (copy ,nonatomic) NSString *topicContent;//名称
@property (copy ,nonatomic) NSString *dir;
@property (assign ,nonatomic) BOOL isTop;
@property (assign ,nonatomic) NSInteger rankFlag;
@property (assign ,nonatomic) NSInteger createUser;
@property (copy ,nonatomic) NSString *createTime;
@property (assign ,nonatomic) NSInteger updateUser;
@property (copy ,nonatomic) NSString *updateTime;
@property (assign ,nonatomic) BOOL delFlag;
@property (assign ,nonatomic) NSInteger commentNum;

@end
