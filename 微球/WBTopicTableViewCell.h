//
//  WBTopicTableViewCell.h
//  微球
//
//  Created by 贾玉斌 on 16/3/1.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTopicModel.h"

@interface WBTopicTableViewCell : UITableViewCell
{
    UIImageView *_backgroungImage;
    UILabel *_titleLabel;
    UIImageView *_leftImage;
    UILabel *_contentLabel;
    UIImageView *_rightImageView;
}

@property (nonatomic, retain) WBTopicModel *model;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)width;
@end
