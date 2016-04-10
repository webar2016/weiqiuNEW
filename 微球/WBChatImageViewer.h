//
//  WBChatImageViewer.h
//  微球
//
//  Created by 徐亮 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD.h"

@interface WBChatImageViewer : RCImagePreviewController

@property (nonatomic,strong)MBProgressHUD *hud;

-(instancetype)initWithChatModel:(RCMessageModel *)model;

@end
