//
//  WBTopicCommentTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/4.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBtopicCommentDetilListModel.h"

@interface WBTopicCommentTableViewCell : UITableViewCell

@property (nonatomic,copy) UIView *backGroundView;
@property (nonatomic,copy) UIImageView *headImageView;
@property (nonatomic,copy) UILabel *nickNameLabel;
@property (nonatomic,copy) UILabel *timeLabel;
@property (nonatomic,copy) UILabel *contentLabel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)height;
- (void)setModel:(WBtopicCommentDetilListModel *)model;
@end
