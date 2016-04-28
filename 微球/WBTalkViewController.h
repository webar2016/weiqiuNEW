//
//  WBTalkViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "MBProgressHUD.h"

@interface WBTalkViewController : RCConversationViewController

@property (nonatomic, assign) BOOL isMaster;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUDIndicator;
-(void)hideHUD;

@end
