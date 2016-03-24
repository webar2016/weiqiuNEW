//
//  WBUpdateScore.m
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBUpdateIntegral.h"

@implementation WBUpdateIntegral

+(NSInteger)getIntegralConfigWithType:(IntegralUpdateType)type{
    NSInteger __block integral;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL_CONFIG,(int)type] whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        integral = [result integerValue];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return integral;
}

+(id)updateUserIntegralFrom:(NSUInteger)userId to:(NSUInteger)anotherUserId withIntegral:(NSInteger)integral{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:UPDATE_INTEGRAL,(int)userId,(int)anotherUserId,(int)integral] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}

+(id)getUserIntegralDetailWithUserId:(NSUInteger)userId{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL_DETAIL,(int)userId] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}

+(id)getUserIntegralWithUserId:(NSUInteger)userId{
    id __block result;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:GET_INTEGRAL,(int)userId] whenSuccess:^(id representData) {
        
        result = [NSJSONSerialization JSONObjectWithData:representData options:NSJSONReadingMutableContainers error:nil];
        
    } andFailure:^(NSString *error) {
        
        NSLog(@"查询失败");
        
    }];
    return result;
}


+(BOOL)checkIntegralWithUserId:(NSUInteger)userId byIntegral:(NSInteger)integral{
    BOOL __block isEnough;
    [MyDownLoadManager getNsurl:[NSString stringWithFormat:CHECK_INTEGRAL,(int)userId,(int)integral] whenSuccess:^(id representData) {
        
        NSString *result = [[NSString alloc]initWithData:representData encoding:NSUTF8StringEncoding];
        if ([result  isEqual: @"true"]) {
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
