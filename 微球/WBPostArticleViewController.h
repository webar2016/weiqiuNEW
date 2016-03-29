//
//  WBPostArticleViewController.h
//  微球
//
//  Created by 徐亮 on 16/3/8.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBPostArticleViewController : UIViewController

@property (nonatomic, assign) BOOL isQuestionAnswer;

@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *qusetionId;

@property (nonatomic,strong)MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@end
