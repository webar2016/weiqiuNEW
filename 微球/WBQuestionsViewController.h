//
//  WBQuestionsTableViewController.h
//  微球
//
//  Created by 徐亮 on 16/2/26.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBQuestionsViewController : UITableViewController

@property (nonatomic, assign) BOOL fromFindView;
@property (nonatomic, assign) BOOL isMaster;
@property (nonatomic, copy) NSString *viewTitle;
@property (nonatomic, assign) int groupId;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUDIndicator;
-(void)hideHUD;

@end
