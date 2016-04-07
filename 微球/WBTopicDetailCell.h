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
//积分不够提醒
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation  cancelMessage:(NSString *)cancelMessage;
//未登录
-(void)unloginAlert;
@end

@interface WBTopicDetailCell : UITableViewCell

@property(nonatomic,assign)id <TransformValue> delegate;

@property (nonatomic,retain) NSIndexPath *indexPath;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withModel:(TopicDetailModel *)model;
@end
