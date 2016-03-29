//
//  WBPositionList.m
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPositionList.h"
#import "WBPositionModel.h"
#import "MJExtension.h"

@interface WBPositionList ()



@end

@implementation WBPositionList

-(NSArray *)provinceArray{
    if (_provinceArray) {
        return _provinceArray;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _provinceArray = (NSArray *)[WBPositionModel mj_objectArrayWithKeyValuesArray:dictionary[@"RECORDS"]];
    return _provinceArray;
}

-(NSArray *)cityArray{
    if (_cityArray) {
        return _cityArray;
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _cityArray = (NSArray *)[WBCityModel mj_objectArrayWithKeyValuesArray:dictionary[@"RECORDS"]];
    return _cityArray;
}

-(NSUInteger)countOfProvinces{
    return self.provinceArray.count;
}

-(NSUInteger)countOfcities{
    return self.cityArray.count;
}

-(NSArray *)getProvinceInfomationAtIndex:(NSUInteger)index{
    WBPositionModel *province = self.provinceArray[index];
    return @[province.provinceName,province.provinceId];
}

-(NSInteger)getCitiesCountWithProvinceId:(NSNumber *)provinceId{
    NSInteger count = 0;
    for (WBCityModel *city in self.cityArray) {
        if (city.provinceId == provinceId) {
            count ++;
        }
    }
    return count;
}

-(NSArray *)getCitiesListWithProvinceId:(NSNumber *)provinceId{
    NSMutableArray *citiesList = [NSMutableArray array];
    for (WBCityModel *city in self.cityArray) {
        if (city.provinceId == provinceId) {
            [citiesList addObject:city];
        }
    }
    return citiesList;
}

-(NSArray *)getCityInfomationAtIndex:(NSUInteger)index WithProvinceId:(NSNumber *)provinceId{
    WBCityModel *city = [self getCitiesListWithProvinceId:provinceId][index];
    return @[city.cityName,city.cityId,city.provinceId];
}

-(NSNumber *)getProvinceIdWithRow:(NSInteger)row{
    WBPositionModel *model = self.provinceArray[row];
    NSNumber *ID = model.provinceId;
    return ID;
}

-(NSNumber *)getCityIdWithRow:(NSInteger)row byProvinceId:(NSNumber *)provinceId{
    NSArray *citiesList = [self getCitiesListWithProvinceId:provinceId];
    WBCityModel *model = citiesList[row];
    NSNumber *ID = model.cityId;
    return ID;
}

-(NSString *)cityNameWithCityId:(NSNumber *)cityId{
    NSString *cityName = [[NSString alloc] init];
    for (WBCityModel *city in self.cityArray) {
        if ([city.cityId isEqualToNumber:cityId]) {
            cityName = city.cityName;
        }
    }
    return cityName;
}

-(NSArray *)searchCityWithCithName:(NSString *)cityName{
    NSMutableArray *cityArr = [NSMutableArray array];
    for (WBCityModel *city in self.cityArray) {
        if ([city.cityName containsString:cityName]) {
            
            [cityArr addObject:@[city.cityName,city.cityId,city.provinceId]];
        }
    }    
    return cityArr;
}


@end
