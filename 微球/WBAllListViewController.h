//
//  WBAllListViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/2/29.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MBProgressHUD.h"


@interface WBAllListViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *dataSource;
@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;
@end
