//
//  WBSystemMessage.h
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 系统通知——活动
 */
#define WBSystemMessageIdentifier @"WB:SystemMsg"

@interface WBSystemMessage : RCMessageContent <NSCoding>

/*!
 活动标题
 */
@property(nonatomic, strong) NSString *title;

/*!
 活动封面图片
 */
@property(nonatomic, strong) NSString *imageURL;

/*!
 活动内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 活动页面的url
 */
@property(nonatomic, strong) NSString *extra;

@end
