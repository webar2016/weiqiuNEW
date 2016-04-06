//
//  WBTopicDetailTableViewCell3.h
//  微球
//
//  Created by 贾玉斌 on 16/3/22.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"
#import "CatZanButton.h"

//代理反相传旨
@protocol TransformValue3 <NSObject>

-(void)changeGetIntegralValue:(NSInteger) modelGetIntegral indexPath:(NSIndexPath *)indexPath;

-(void)commentClickedPushView:(NSIndexPath *)indexPath;
//去个人主页
-(void)gotoHomePage:(NSIndexPath *)indexPath;
//积分不够提醒
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation;
//积分不够提醒
-(void)alertViewIntergeal:(NSString *)messageContent messageOpreation:(NSString *)opreation  cancelMessage:(NSString *)cancelMessage;
@end


@interface WBTopicDetailTableViewCell3 : UITableViewCell
{

CatZanButton *_zanBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


- (void)setModel:(TopicDetailModel *)model  labelHeight:(CGFloat)labelHeight;

@property (nonatomic, retain) TopicDetailModel *model;

@property (nonatomic,retain) NSIndexPath *indexPath;

@property(nonatomic,assign)id<TransformValue3> delegate;//实现代理
@end
