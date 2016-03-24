//
//  WBTbl_Unlock_City.h
//  微球
//
//  Created by 贾玉斌 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTbl_Unlock_City : NSObject
@property (nonatomic,assign)int Id;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,copy) NSDate *unlockDate;
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger marked;
@end
