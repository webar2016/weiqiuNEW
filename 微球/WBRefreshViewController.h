//
//  WBRefreshViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/4/5.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBRefreshViewController : UIViewController

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUDText:(NSString *)title;
-(void)showHUDIndicator;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;
-(void)hideHUDDelay:(NSTimeInterval)delay;

@end
