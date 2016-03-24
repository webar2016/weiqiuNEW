//
//  WBUnlockMsgCell.h
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "WBUnlockMessage.h"

@interface WBUnlockMsgCell : RCMessageCell

+ (CGSize)getBubbleBackgroundViewSize:(WBUnlockMessage *)message;

@end
