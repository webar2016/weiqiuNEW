//
//  WBUpdateScore.m
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUpdateIntegral.h"

@implementation WBUpdateIntegral

+(NSString *)getIntegralConfigWithType:(IntegralUpdateType)type{
    NSString __block *integral;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL_CONFIG,(int)type] whenSuccess:^(id representData) {
        
        integral = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return integral;
}

+(NSDictionary *)updateUserByUpdateType:(IntegralUpdateType)type withIntegral:(NSString *)integral{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:UPDATE_INTEGRAL,[WBUserDefaults userId],type,integral] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}

+(id)getUserIntegralDetail{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL_DETAIL,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}

+(id)getUserIntegral{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL,[WBUserDefaults userId]] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}


+(BOOL)checkIntegralByNeededIntegral:(NSString *)integral{
    BOOL __block isEnough;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:CHECK_INTEGRAL,[WBUserDefaults userId],integral] whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result isEqualToString: @"true"]) {
            isEnough = 1;
        }else{
            isEnough = 0;
        }
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
    }];
    return isEnough;
}

@end
