//
//  WBCollectionViewModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TblUser_colltion : NSObject

@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *dir;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger cityNum;
@property (nonatomic,assign) NSInteger provinceNum;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger countryId;
@property (nonatomic,copy) NSString *profile;
@property (nonatomic,copy) NSString *position;

@end


@interface WBCollectionViewModel : NSObject

@property (nonatomic,assign) NSInteger groupId;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger rewardIntegral;
@property (nonatomic,assign) NSInteger canUseIntegral;
@property (nonatomic,assign) NSInteger destinationId;
@property (nonatomic,copy) NSString *beginTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *planBegin;
@property (nonatomic,copy) NSString *planEnd;
@property (nonatomic,assign) NSInteger members;
@property (nonatomic,assign) NSInteger maxMembers;
@property (nonatomic,copy) NSString *groupSign;
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,copy) NSString *destination;
@property (nonatomic,copy) NSString *groupSignStr;

@property (nonatomic,copy) NSString *theme;
@property (nonatomic,assign) NSInteger rankFlag;
@property (nonatomic,copy) NSString *dir;
@property (nonatomic,assign) NSInteger createUser;
@property (nonatomic,assign) NSInteger createTime;
@property (nonatomic,assign) NSInteger updateUser;
@property (nonatomic,assign) NSInteger updateTime;
@property (nonatomic,assign) BOOL delFlag;
@property (nonatomic,retain)TblUser_colltion *tblUser;
@property (nonatomic,copy) NSString *imgRate;


@end


