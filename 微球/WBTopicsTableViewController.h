//
//  WBTopicsTableViewController.h
//  微球
//
//  Created by 徐亮 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBTopicsTableViewController : UITableViewController
@property (nonatomic,strong)MBProgressHUD *hud;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;
@end
