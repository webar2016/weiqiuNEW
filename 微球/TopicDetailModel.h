//
//  TopicDetailModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TblUser : NSObject

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
@property (nonatomic,assign) NSInteger qNum;
@end


@interface TopicDetailModel : NSObject
@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger topicId;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,assign) NSInteger newsType;
@property (nonatomic,copy) NSString *dir;
@property (nonatomic,copy) NSString *commentTime;
@property (nonatomic,assign) NSInteger praiseTimes;
@property (nonatomic,assign) NSInteger praiseUser;
@property (nonatomic,assign) NSInteger getIntegral;  //赞数
@property (nonatomic,assign) NSInteger rankFlag;
@property (nonatomic,assign) NSInteger createUser;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign) NSInteger updateUser;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,assign) BOOL delFlag;
@property (nonatomic,assign) BOOL isFriend;
@property (nonatomic,strong) TblUser *tblUser;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,assign) NSInteger descussNum;   //评论树木
@property (nonatomic,assign) NSInteger mediaPic;
@property (nonatomic,copy) NSString *imgRate;
@end


