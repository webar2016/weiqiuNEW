//
//  WBHomeFirstPageTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/22.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailModel.h"

@interface WBHomeFirstPageTableViewCell : UITableViewCell
- (void)setModel:(TopicDetailModel *)model withLabelHeight:(CGFloat)labelHeight;

@property(nonatomic,retain)TopicDetailModel *model;
@end
