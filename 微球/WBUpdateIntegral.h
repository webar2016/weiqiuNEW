//
//  WBUpdateScore.h
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDownLoadManager.h"

/**
 *查询积分配置信息
 */
#define GET_INTEGRAL_CONFIG @"http://app.weiqiu.me/integral/getIntegralConfigDetil?typeFlag=%d"

/**
 *添加或扣减用户积分
 */
#define UPDATE_INTEGRAL @"http://app.weiqiu.me/integral/updateUserIntegral?userId=%@&updateType=%d&updateNum=%@"

/**
 *获取用户积分流水
 */
#define GET_INTEGRAL_DETAIL @"http://app.weiqiu.me/integral/getUserIntegralDetil?userId=%@"

/**
 *获取用户积分信息
 */
#define GET_INTEGRAL @"http://app.weiqiu.me/integral/getUserIntegral?userId=%@"

/**
 *检查用户积分是否够用
 */
#define CHECK_INTEGRAL @"http://app.weiqiu.me/integral/checkIntegral?userId=%@&updateNum=%@"

/**
 *积分更新类型
 */
typedef NS_ENUM(NSInteger, IntegralUpdateType) {
    IntegralUpdateTypeRegister = 1,         //  注册---1
    IntegralUpdateTypeGuess = 2,            //  猜图---2
    IntegralUpdateTypeUnlock = 3,           //  解锁---3
    IntegralUpdateTypeHelpGroup = 4,        //  帮帮团---4
    IntegralUpdateTypePraise = 5,           //  打赏---5
    IntegralUpdateTypeAppRecharge = 6,      //  APP充值---6
    IntegralUpdateTypeWXRecharge = 7,       //  微信充值---7
    IntegralUpdateTypeCash = 8              //  提现---8
};

/**
 *积分更新
 */
typedef NS_ENUM(NSInteger, IntegralConfig) {
    IntegralConfigRegister = 1,             //  注册奖励---1
    IntegralConfigGuessBase = 2,            //  猜图基础---2
    IntegralConfigGuess = 3,                //  猜图积分---3
    IntegralConfigUnlock = 4,               //  解锁积分---4
    IntegralConfigGroupRate = 5,            //  帮帮团税率---5
    IntegralConfigPraise = 6,               //  点赞积分---6
    IntegralConfigAppRate = 7,              //  APP充值税率---7
    IntegralConfigWXRate = 8,               //  微信充值税率---8
    IntegralConfigCashRate = 9,             //  提现税率---9
    IntegralConfigShare = 10,               //  分享积分---10
    IntegralConfigSubscribe = 11            //  订阅积分---11
};


@interface WBUpdateIntegral : NSObject

/**
 *查询积分配置信息
 */
+(NSString *)getIntegralConfigWithType:(IntegralUpdateType)type;

/**
 *添加或扣减用户积分
 */
+(NSDictionary *)updateUserByUpdateType:(IntegralUpdateType)type withIntegral:(NSString *)integral;

/**
 *获取用户积分流水
 */
+(NSDictionary *)getUserIntegralDetail;

/**
 *获取用户积分信息
 */
+(NSDictionary *)getUserIntegral;

/**
 *检查用户积分是否够用
 */
+(BOOL)checkIntegralByNeededIntegral:(NSString *)integral;

@end
