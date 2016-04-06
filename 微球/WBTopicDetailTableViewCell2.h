//
//  WBTopicDetailTableViewCell2.h
//  微球
//
//  Created by 贾玉斌 on 16/3/31.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "MyDownLoadManager.h"
#import "WBTopicCommentTableViewController.h"
#import "CatZanButton.h"

@protocol TransformValue2 <NSObject>

-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath;

-(void)commentClickedPushView:(NSIndexPath *)indexPath;

-(void)playMedio:(NSIndexPath *)indexPath;
//去个人主页
-(void)gotoHomePage:(NSIndexPath *)indexPath;
//积分不够提醒
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation  cancelMessage:(NSString *)cancelMessage;
@end

@interface WBTopicDetailTableViewCell2 : UITableViewCell
{
    UIView *_background;
    
    
    UIView *_mainView;
    UIImageView *_headImageView;
    UILabel *_nickName;
    UILabel *_timeLabel;
    UIButton *_attentionButton;
    UIImageView *_mainImageView;
    UILabel *_contentLabel;
    
    
    UIView *_footerView;
    UIButton *_shareButton;
    UIButton *_commentButton;
    UIButton *_praiseButton;
    
    CatZanButton *_zanBtn;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;

- (void)setModel:(TopicDetailModel *)model labelHeight:(CGFloat)labelHeight;

@property (nonatomic, retain) TopicDetailModel *model;

@property (nonatomic,retain) NSIndexPath *indexPath;

@property(nonatomic,assign)id<TransformValue2> delegate;//实现代理
@end
