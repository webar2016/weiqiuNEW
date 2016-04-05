//
//  WBAttentionView.h
//  微球
//
//  Created by 贾玉斌 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBAttentionView : UIViewController


@property (nonatomic,copy)NSString *showUserId;


@property (nonatomic,strong)MBProgressHUD *hud;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;
@end
