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

@end







@interface WBCityModel : NSObject

@property (nonatomic, weak) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, weak) NSNumber *provinceId;

@end
