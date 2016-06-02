//
//  WBGroupSettingViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCollectionViewModel.h"
#import "MBProgressHUD.h"

@interface WBGroupSettingViewController : UITableViewController

@property (nonatomic, assign) BOOL isMaster;

@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, strong) WBCollectionViewModel *groupDetail;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUDText:(NSString *)title;

@end
