//
//  WBtopicCommentDetilListModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
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
@property (nonatomic,assign)NSInteger userId;
@end


@interface WBtopicCommentDetilListModel : NSObject
@property (nonatomic,assign)NSInteger id;
@property (nonatomic,assign)NSInteger commentId;
@property (nonatomic,copy) NSString *comment;
@property (nonatomic,assign)NSInteger touserId;
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,copy) NSString *commentTime;
@property (nonatomic,assign)NSInteger createUser;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,assign)NSInteger updateUser;
@property (nonatomic,copy) NSString *updateTime;
@property (nonatomic,assign) BOOL delFlag;
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic,strong) UserInfo *toUserInfo;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic, assign) NSInteger typeFlag;
@end
