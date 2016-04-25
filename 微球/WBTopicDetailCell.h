//
//  WBTopicDetailCell.h
//  微球
//
//  Created by 徐亮 on 16/4/6.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"
#import "WBTopicCommentTableViewController.h"

@protocol TransformValue <NSObject>
@optional
//改变积分
-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath;
//评论页面
-(void)commentClickedPushView:(NSIndexPath *)indexPath;
//去个人主页
-(void)gotoHomePage:(NSIndexPath *)indexPath;
//播放视频
-(void)playMedio:(NSIndexPath *)indexPath;
//照片大图
-(void)showImageViewer:(NSIndexPath *)indexPath;
//积分不够提醒
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation  cancelMessage:(NSString *)cancelMessage;
//未登录
-(void)unloginAlert;

/**
 *仅显示文字
 */
-(void)showHUDText:(NSString *)title;

/**
 *仅显示菊花
 */
-(void)showHUDIndicator;
-(void)showHUD:(NSString *)title isDim:(BOOL)isDim;
-(void)showHUDComplete:(NSString *)title;
-(void)hideHUD;
-(void)hideHUDDelay:(NSTimeInterval)delay;



@end

@interface WBTopicDetailCell : UITableViewCell

@property(nonatomic,assign)id <TransformValue> delegate;

@property (nonatomic,copy) NSIndexPath *indexPath;

@property (nonatomic,retain) TopicDetailModel *model;

@property (nonatomic,copy) NSString *cover;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setModel:(TopicDetailModel *)model;

-(void)setModel:(TopicDetailModel *)model withIsSelectState:(NSString *)selectState;
@end
