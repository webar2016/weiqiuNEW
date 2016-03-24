//
//  WBAllocateScoreModel.h
//  微球
//
//  Created by 贾玉斌 on 16/3/11.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WBAllocateScoreModel : NSObject

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString  *nickname;
@property (nonatomic,copy) NSString  *dir;
@property (nonatomic,copy) NSString  *sex;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,assign) NSInteger cityNum;
@property (nonatomic,assign) NSInteger provinceNum;
@property (nonatomic,assign) NSInteger state;
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger countryId;
@property (nonatomic,copy) NSString  *profile;
@property (nonatomic,copy) NSString  *position;
@property (nonatomic,assign) NSInteger qNum;




@end
