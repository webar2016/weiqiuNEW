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
@property (nonatomic, copy) NSString *cityStr;
@property (nonatomic, copy) NSString *isSolved;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, assign) NSInteger allAnswers;
@property (nonatomic, assign) NSInteger allIntegral;
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) BOOL fromFindView;
@property (nonatomic, assign) BOOL isMaster;


@property (nonatomic,strong) MBProgressHUD *hud;

-(void)showHUDIndicator;
-(void)showHUDText:(NSString *)title;
-(void)hideHUD;

@end
