//
//  WBArticalViewController.h
//  微球
//
//  Created by 徐亮 on 16/4/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBArticalViewController : UIViewController

@property (nonatomic,assign) NSInteger commentId;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *dir;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;


@end
