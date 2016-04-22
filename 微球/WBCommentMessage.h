//
//  WBActiveMessage.h
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 评论推送
 */
#define WBCommentMessageIdentifier @"WB:CommentMsg"

@interface WBCommentMessage : RCMessageContent <NSCoding>

/*!
 评论用户昵称  “@ nickname 评论了你，点击查看详情！”
 */
@property(nonatomic, strong) NSString *nickname;

/*!
 评论用户头像
 */
@property(nonatomic, strong) NSString *imageURL;

/*!
 评论内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 评论内容
 */
@property(nonatomic, strong) NSString *userId;

/*!
 被评论状态id
 */
@property(nonatomic, strong) NSString *extra;

@end
