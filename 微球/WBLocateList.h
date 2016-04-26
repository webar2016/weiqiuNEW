//
//  WBLocateList.h
//  微球
//
//  Created by 贾玉斌 on 16/4/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBPositionList.h"

@interface WBLocateList : NSObject
@property (nonatomic,copy)NSMutableArray *areaArray;
@property (nonatomic,copy)NSMutableArray *countryArray;
/**
 *返回所有信息
 */
-(NSArray *)getAllAreaList;






















@end
