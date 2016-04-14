//
//  WBPositionList.h
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBPositionModel.h"


@interface WBPositionList : NSObject


/**
 *获取国内省份城市列表
 */
@property (nonatomic, strong) NSArray *provinceArray;
@property (nonatomic, strong) NSArray *cityArray;

/**
 *获取国内省份城市数量
 */
-(NSUInteger)countOfProvinces;
-(NSUInteger)countOfcities;


/**
 *返回指定位置的省份及其ID
 *返回包含一个省份信息的数组[name,ID]
 */
-(NSArray *)getProvinceInfomationAtIndex:(NSUInteger)index;

/**
 *传入省份ID
 *返回该省份的所有城市和城市数量
 *返回WBCityModel对象数组
 *返回包含一个城市信息的数组[cityName,cityID,provinceID]
 */
-(NSInteger)getCitiesCountWithProvinceId:(NSNumber *)provinceId;
-(NSArray *)getCitiesListWithProvinceId:(NSNumber *)provinceId;
-(NSArray *)getCityInfomationAtIndex:(NSUInteger)index WithProvinceId:(NSNumber *)provinceId;

/**
 *获取provinceId
 */
-(NSNumber *)getProvinceIdWithRow:(NSInteger)row;


/**
 *获取cityId
 */
-(NSNumber *)getCityIdWithRow:(NSInteger)row byProvinceId:(NSNumber *)provinceId;

/**
 *根据cityId返回cityName
 */
-(NSString *)cityNameWithCityId:(NSNumber *)cityId;
-(WBCityModel *)cityModelWithCityId:(NSNumber *)cityId;
/**
 *根据搜索的城市名显示城市
 *返回数组
 */
-(NSArray *)searchCityWithCithName:(NSString *)cityName;


@end
