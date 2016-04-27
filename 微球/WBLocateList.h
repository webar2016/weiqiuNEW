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
@property (nonatomic,copy)NSArray *areaArray;
@property (nonatomic,copy)NSArray *countryArray;
@property (nonatomic,copy)NSArray *provinceArray;
@property (nonatomic,copy)NSArray *cityArray;


-(NSArray *)getAllAreaList;

-(NSArray *)getAllCountryList;

-(NSArray *)getAllProvinceList;

-(NSArray *)getAllCityList;

-(NSDictionary *)searchPositionById:(NSInteger)number;




+(NSArray *)myGetAllAreaList;

+(NSArray *)myGetAllCountryList;

+(NSArray *)myGetAllProvinceList;

+(NSArray *)myGetAllCityList;


//获取这个number的信息
+(NSDictionary *)mySearchPositionById:(NSInteger)number;
//获取这个数据类型
+(NSInteger )myGetPositionTypeById:(NSInteger)number;
//获取数字所对应的名称
+(NSString *)myGetPositionNameById:(NSInteger)number;










@end
