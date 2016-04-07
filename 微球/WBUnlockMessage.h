//
//  WBUnlockMessage.h
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 解锁通知消息
 */
#define WBUnlockMessageIdentifier @"WB:UnlockMsg"

@interface WBUnlockMessage : RCMessageContent <NSCoding>

/*!
 解锁通知内容
 成功为 “您成功解锁了XX省XX市，占领全国XX%的土地，世界排名XXX名”
 失败为 “很遗憾，您未能解锁XX省XX市，点击即刻重新解锁！”
 */
@property(nonatomic, strong) NSString *content;

/*!
 解锁使用的图片
 */
@property(nonatomic, strong) NSString *imageURL;

/*!
 解锁是否通过，返回YES/NO
 */
@property(nonatomic, strong) NSString *isUnlock;

/*!
 解锁城市cityId
 */
@property(nonatomic, strong) NSString *cityId;

/*!
图片比例
 */
@property(nonatomic, strong) NSString *extra;

@end
