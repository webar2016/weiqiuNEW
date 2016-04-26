//
//  WBPositionModel.h
//  微球
//
//  Created by 徐亮 on 16/3/12.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBPositionModel : NSObject

@property (nonatomic, weak) NSNumber *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic,copy) NSArray *citys;
@end


@interface WBProvinceModel : NSObject

@property (nonatomic, weak) NSNumber *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic,copy) NSArray *citys;
@end





@interface WBCityModel : NSObject

@property (nonatomic, weak) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, weak) NSNumber *provinceId;

@end



@interface WBBigAreaModel : NSObject

@property (nonatomic, weak) NSNumber *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, assign) BOOL isCountry;
@property (nonatomic,copy) NSArray *countrys;

@end


@interface WBCountryModel : NSObject

@property (nonatomic, weak) NSNumber *id;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *mobile_prefix;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, weak) NSNumber *areaId;
@property (nonatomic, weak) NSNumber *areaSize;
@property (nonatomic,copy) NSArray *provinces;

@end