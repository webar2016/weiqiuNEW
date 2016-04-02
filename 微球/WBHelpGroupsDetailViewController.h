//
//  WBHelpGroupsDetailViewController.h
//  微球
//
//  Created by 贾玉斌 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBCollectionViewModel.h"
#import "MBProgressHUD.h"

@interface WBHelpGroupsDetailViewController : UIViewController


@property (nonatomic,retain) WBCollectionViewModel *model;
@property (nonatomic,assign) CGFloat imageHeight;



@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@end
