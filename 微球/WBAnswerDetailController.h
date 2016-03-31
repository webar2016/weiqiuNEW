//
//  WBAnswerDetailController.h
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WBAnswerDetailController : UIViewController

@property (nonatomic, copy) NSString *questionText;
@property (nonatomic, assign) NSInteger answerId;
@property (nonatomic, strong) NSURL *dir;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) NSInteger getIntegral;
@property (nonatomic, assign) NSInteger userId;

/**
 *点击问题后传给下一个controller的数据
 */
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, assign) NSInteger allAnswers;
@property (nonatomic, assign) NSInteger allIntegral;

/**
 *是否从答案列表页跳转
 */
@property (nonatomic, assign) BOOL hasPrevPage;

@property (nonatomic, assign) BOOL fromFindView;
@property (nonatomic, assign) BOOL isMaster;


@property (nonatomic,strong) MBProgressHUD *hud;

-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;

@end
