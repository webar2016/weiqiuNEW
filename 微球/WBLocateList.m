//
//  WBLocateList.m
//  微球
//
//  Created by 贾玉斌 on 16/4/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBLocateList.h"
#import "MJExtension.h"

@implementation WBLocateList


-(NSArray *)getAllAreaList{
    if (_areaArray) {
        return _areaArray;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Localtion" ofType:@"plist"];
    NSArray *areaArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    _areaArray = (NSMutableArray *)[WBBigAreaModel mj_objectArrayWithKeyValuesArray:areaArray];
    return _areaArray;

}

@end
