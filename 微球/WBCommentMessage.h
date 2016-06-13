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
@property(nonatomic, copy) NSString *nickname;

/*!
 评论用户头像
 */
@property(nonatomic, copy) NSString *imageURL;

/*!
 评论内容
 */
@property(nonatomic, copy) NSString *content;

/*!
 评论内容
 */
@property(nonatomic, copy) NSString *userId;

/*!
 被评论状态id
 */
@property(nonatomic, copy) NSString *extra;

@end
