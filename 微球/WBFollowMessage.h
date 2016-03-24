//
//  WBFollowMessage.h
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 订阅用户提醒
 */
#define WBFollowMessageIdentifier @"WB:FollowMsg"

@interface WBFollowMessage : RCMessageContent <NSCoding>

/*!
 订阅用户提醒信息，内容固定为 "又有球友关注你啦！快来看看吧！"
 */
//@property(nonatomic, strong) NSString *content;

/*!
 订阅用户头像
 */
@property(nonatomic, strong) NSString *imageURL;

/*!
 订阅用户昵称
 */
@property(nonatomic, strong) NSString *nickname;

/*!
 订阅用户userId
 */
@property(nonatomic, strong) NSString *extra;

@end
