//
//  WBAnswerListController.h
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBQuestionsListModel.h"
#import "MBProgressHUD.h"

@interface WBAnswerListController : UITableViewController

@property (nonatomic, copy) NSString *questionText;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, assign) NSInteger allAnswers;
@property (nonatomic, assign) NSInteger allIntegral;

@property (nonatomic, assign) BOOL fromFindView;
@property (nonatomic, assign) BOOL isMaster;


@property (nonatomic,strong) MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@end
