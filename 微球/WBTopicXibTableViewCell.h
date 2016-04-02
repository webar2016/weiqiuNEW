//
//  WBTopicXibTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/4/2.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"
//代理反相传旨
@protocol TransformXibValue <NSObject>
//改变积分
-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath;
//评论页面
-(void)commentClickedPushView:(NSIndexPath *)indexPath;
//去个人主页
-(void)gotoHomePage:(NSIndexPath *)indexPath;
//播放视频
-(void)playMedio:(NSIndexPath *)indexPath;
@end


@interface WBTopicXibTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;




- (void)configModel:(TopicDetailModel *)model indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,retain) NSIndexPath *indexPath;

@property (nonatomic, retain) TopicDetailModel *model;





@property(nonatomic,assign)id<TransformXibValue> delegate;//实现代理
@end
